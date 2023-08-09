"use strict";

import { GetItemCommand, QueryCommand } from "@aws-sdk/client-dynamodb";

import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
import {
  getOptionalValueString,
  getOptionalValueNumeric,
} from "/opt/nodejs/utils.mjs";

export const buildMeasurementFromDynamoDbRecord = (element) => {
  console.log("element:", element);
  return {
    userId: element.UserId.S,
    measurementId: element.MeasurementId.S,
    timestamp: Number(element.Timestamp.N),
    date: Number(element.MeasurementDate.N),
    note: getOptionalValueString(element.Note),
    measurements: {
      weight: Number(element.Weight.N),
      bodyFatPercentage: getOptionalValueNumeric(element.BodyFatPercentage),
      waterPercentage: getOptionalValueNumeric(element.WaterPercentage),
      muscleMassPercentage: getOptionalValueNumeric(
        element.MuscleMassPercentage
      ),
      bonePercentage: getOptionalValueNumeric(element.BonePercentage),
      energyExpenditure: getOptionalValueNumeric(element.EnergyExpenditure),
    },
  };
};

export const buildDynamoDbParamsRetrieveAllMeasurements = (
  tableName,
  userId
) => {
  return {
    TableName: tableName,
    KeyConditionExpression: "UserId = :userId",
    ExpressionAttributeValues: {
      ":userId": { S: userId },
    },
  };
};

export const buildDynamoDbParamsRetrieveSingleMeasurement = (
  tableName,
  userId,
  measurementId
) => {
  return {
    TableName: tableName,
    Key: {
      UserId: { S: userId },
      MeasurementId: { S: measurementId },
    },
  };
};

export const retrieveAllMeasurements = async (tableName, userId) => {
  const params = buildDynamoDbParamsRetrieveAllMeasurements(tableName, userId);
  console.log("params:", params);

  const retrievedData = await ddbClient.send(new QueryCommand(params));
  const measurements = [];

  if (retrievedData.Items != null) {
    retrievedData.Items.forEach((record) => {
      measurements.push(buildMeasurementFromDynamoDbRecord(record));
    });
  }

  return measurements;
};

export const retrieveSingleMeasurement = async (
  tableName,
  userId,
  measurementId
) => {
  const params = buildDynamoDbParamsRetrieveSingleMeasurement(
    tableName,
    userId,
    measurementId
  );
  console.log("params:", params);

  const retrievedData = await ddbClient.send(new GetItemCommand(params));
  let measurement;

  if (retrievedData.Item != null) {
    measurement = buildMeasurementFromDynamoDbRecord(retrievedData.Item);
  }

  return measurement;
};
