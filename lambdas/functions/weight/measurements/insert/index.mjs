"use strict";

import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { randomUUID } from "node:crypto";

import { buildMeasurement } from "./measurements.mjs";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { retrieveSingleMeasurement } from "/opt/nodejs/measurementUtils.mjs";

const REGION = process.env.AWS_REGION;
const ddbClient = new DynamoDBClient({ region: REGION });

export const handler = async (event, context) => {
  console.info("measurement: ", event.measurement);
  console.info("userId: ", event.measurement.userId);

  const tableName = process.env.TABLE_NAME;
  const userId = event.measurement.userId;
  const measurementId = randomUUID();
  const date = event.measurement.date;
  const note = event.measurement.note;
  const weight = event.measurement.measurements.weight;
  const bodyFatPercentage = event.measurement.measurements.bodyFatPercentage;
  const waterPercentage = event.measurement.measurements.waterPercentage;
  const muscleMassPercentage =
    event.measurement.measurements.muscleMassPercentage;
  const bonePercentage = event.measurement.measurements.bonePercentage;
  const energyExpenditure = event.measurement.measurements.energyExpenditure;

  const measurement = buildMeasurement(
    tableName,
    userId,
    measurementId,
    date,
    weight,
    note,
    bodyFatPercentage,
    waterPercentage,
    muscleMassPercentage,
    bonePercentage,
    energyExpenditure
  );

  let response;

  try {
    const measurementMetadata = await ddbClient.send(
      new PutItemCommand(measurement)
    );
    console.info(measurementMetadata);

    const retrievedMeasurement = await retrieveSingleMeasurement(
      REGION,
      tableName,
      userId,
      measurementId
    );

    const responseBody = {
      measurementId: measurementId,
      measurement: retrievedMeasurement,
    };
    response = buildResponse(200, responseBody);

    console.info("response", response);
    return response;
  } catch (err) {
    console.error(err);

    response = buildErrorResponse(500, err);
    context.fail(JSON.stringify(response));
  }
};
