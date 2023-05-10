"use strict";

import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { randomUUID } from "node:crypto";

import { buildMeasurement } from "./measurements.mjs";
import { validateMeasurement } from "./validation.mjs";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { retrieveSingleMeasurement } from "/opt/nodejs/measurementUtils.mjs";

const REGION = process.env.AWS_REGION;
const ddbClient = new DynamoDBClient({ region: REGION });

export const handler = async (event, context) => {
  console.info("measurement: ", event.measurement);
  console.info("userId: ", event.measurement.userId);

  const tableName = process.env.TABLE_NAME;

  const measurement = {
    userId: event.measurement.userId,
    measurementId: randomUUID(),
    date: event.measurement.date,
    note: event.measurement.note,
    weight: event.measurement.measurements.weight,
    bodyFatPercentage: event.measurement.measurements.bodyFatPercentage,
    waterPercentage: event.measurement.measurements.waterPercentage,
    muscleMassPercentage: event.measurement.measurements.muscleMassPercentage,
    bonePercentage: event.measurement.measurements.bonePercentage,
    energyExpenditure: event.measurement.measurements.energyExpenditure,
  };

  let response;

  try {
    validateMeasurement(measurement);
  } catch (err) {
    console.error("Validation error:", err.message);

    response = buildErrorResponse(400, err.message);
    context.fail(JSON.stringify(response));
  }

  try {
    const measurementDataDynamoDb = buildMeasurement(tableName, measurement);
    const measurementMetadata = await ddbClient.send(
      new PutItemCommand(measurementDataDynamoDb)
    );
    console.info(measurementMetadata);

    const retrievedMeasurement = await retrieveSingleMeasurement(
      REGION,
      tableName,
      measurement.userId,
      measurement.measurementId
    );

    const responseBody = {
      measurementId: measurement.measurementId,
      measurement: retrievedMeasurement,
    };
    response = buildResponse(200, responseBody);

    console.info("response", response);
    return response;
  } catch (err) {
    console.error("Error while processing:", err);

    response = buildErrorResponse(500, err.message);
    context.fail(JSON.stringify(response));
  }
};
