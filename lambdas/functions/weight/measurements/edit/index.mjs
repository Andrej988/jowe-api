"use strict";

import { UpdateItemCommand } from "@aws-sdk/client-dynamodb";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
import { buildMeasurementFromDynamoDbRecord } from "/opt/nodejs/measurements/utils.mjs";

const addOptionalStringParam = (params, key, value) => {
  if (value) {
    params.ExpressionAttributeValues[key] = { S: value };
  } else {
    params.ExpressionAttributeValues[key] = { NULL: true };
  }
};

const addOptionalNumericParam = (params, key, value) => {
  if (value) {
    params.ExpressionAttributeValues[key] = { N: "" + value };
  } else {
    params.ExpressionAttributeValues[key] = { NULL: true };
  }
};

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
      "set MeasurementDate = :measurementDate, Weight = :weight, LastModified = :lastModified, Note = :note, BodyFatPercentage = :bodyFat, WaterPercentage = :water, MuscleMassPercentage = :muscleMass, BonePercentage = :boneMass, EnergyExpenditure = :energyExpenditure",
    ExpressionAttributeValues: {
      ":measurementDate": {
        N: "" + measurement.date,
      },
      ":weight": {
        N: "" + measurement.weight,
      },
      ":lastModified": {
        N: "" + Date.now(),
      },
    },
    ReturnValues: "ALL_NEW",
  };

  addOptionalStringParam(params, ":note", measurement.note);
  addOptionalNumericParam(params, ":bodyFat", measurement.bodyFatPercentage);
  addOptionalNumericParam(params, ":water", measurement.waterPercentage);
  addOptionalNumericParam(
    params,
    ":muscleMass",
    measurement.muscleMassPercentage
  );
  addOptionalNumericParam(params, ":boneMass", measurement.bonePercentage);
  addOptionalNumericParam(
    params,
    ":energyExpenditure",
    measurement.energyExpenditure
  );
  console.log("params", params);

  let response;

  try {
    const data = await ddbClient.send(new UpdateItemCommand(params));
    console.info("Success, item edited", data);

    const retrievedMeasurement = buildMeasurementFromDynamoDbRecord(
      data.Attributes
    );
    console.log(retrievedMeasurement);

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
