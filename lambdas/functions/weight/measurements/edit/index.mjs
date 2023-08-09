"use strict";

import { UpdateItemCommand } from "@aws-sdk/client-dynamodb";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
import { buildMeasurementFromDynamoDbRecord } from "/opt/nodejs/measurements/utils.mjs";

export const handler = async (event) => {
  console.info("measurement: ", event.measurement);
  console.info("userId: ", event.measurement.userId);

  const tableName = process.env.TABLE_NAME;

  const measurement = {
    userId: event.measurement.userId,
    measurementId: event.measurement.measurementId,
    date: event.measurement.date,
    note: event.measurement.note,
    weight: event.measurement.measurements.weight,
    bodyFatPercentage: event.measurement.measurements.bodyFatPercentage,
    waterPercentage: event.measurement.measurements.waterPercentage,
    muscleMassPercentage: event.measurement.measurements.muscleMassPercentage,
    bonePercentage: event.measurement.measurements.bonePercentage,
    energyExpenditure: event.measurement.measurements.energyExpenditure,
  };

  const params = {
    TableName: tableName,
    Key: {
      UserId: { S: measurement.userId },
      MeasurementId: { S: measurement.measurementId },
    },
    UpdateExpression:
      "set MeasurementDate = :measurementDate, Weight = :weight, LastModified = :lastModified, Note = :note, BodyFatPercentage = :bodyFat",
    ExpressionAttributeValues: {
      ":measurementDate": {
        N: "" + measurement.date,
      },
      ":weight": {
        N: "" + measurement.weight,
      },
      ":note": {
        S: measurement.note,
      },
      ":bodyFat": {
        N: "" + measurement.bodyFatPercentage,
      },
      ":lastModified": {
        N: "" + Date.now(),
      },
    },
    ReturnValues: "ALL_NEW",
  };

  let response;

  try {
    const data = await ddbClient.send(new UpdateItemCommand(params));
    console.info("Success, item edited", data);

    const retrievedMeasurmeent = buildMeasurementFromDynamoDbRecord(data.Attributes);
    console.log(retrievedMeasurmeent);

    const responseBody = {
      measurement: retrievedMeasurement,
    };
    response = buildResponse(200, responseBody);

    console.info("response", response);
    return response;
  } catch (err) {
    console.error(err);
    response = buildErrorResponse(500, err.message);
    context.fail(JSON.stringify(response));
  }
};
