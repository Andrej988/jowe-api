"use strict";

import {
  DynamoDBClient,
  GetItemCommand,
  QueryCommand,
} from "@aws-sdk/client-dynamodb";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import {
  buildMeasurementFromDynamoDbRecord,
  buildDynamoDbParamsRetrieveAllMeasurements,
  buildDynamoDbParamsRetrieveSingleMeasurement,
} from "/opt/nodejs/measurementUtils.mjs";

const REGION = process.env.AWS_REGION;
const ddbClient = new DynamoDBClient({ region: REGION });

export const handler = async (event) => {
  console.log("event", event);
  const type = event.type;
  const tableName = process.env.TABLE_NAME;
  const userId = event.userId;
  const measurementId = event.measurementId;

  console.log("tableName:", tableName);
  console.log("UserId:", userId);
  console.log("MeasurementId:", measurementId);

  let response;
  let measurements = [];

  if (type === "all") {
    const params = buildDynamoDbParamsRetrieveAllMeasurements(
      tableName,
      userId
    );
    console.log("params:", params);

    try {
      const measurementsData = await ddbClient.send(new QueryCommand(params));
      measurementsData.Items.forEach((row) => {
        measurements.push(buildMeasurementFromDynamoDbRecord(row));
      });

      response = buildResponse(200, measurements);
    } catch (err) {
      console.error(err);
      response = buildErrorResponse(500, err);
    }
  } else if (type === "single") {
    const params = buildDynamoDbParamsRetrieveSingleMeasurement(
      tableName,
      userId,
      measurementId
    );
    console.log("params:", params);

    const measurementData = await ddbClient.send(new GetItemCommand(params));
    console.log("Success", measurementData.Item);

    if (measurementData.Item != null) {
      measurements.push(
        buildMeasurementFromDynamoDbRecord(measurementData.Item)
      );
    }

    response = buildResponse(200, measurements);
  } else {
    response = buildErrorResponse(400, "Wrong query type!");
  }

  return response;
};
