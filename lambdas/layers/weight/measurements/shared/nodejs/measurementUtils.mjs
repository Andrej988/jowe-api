"use strict";

import {
  DynamoDBClient,
  GetItemCommand,
  QueryCommand,
} from "@aws-sdk/client-dynamodb";

const getOptionalValueString = (value) => {
  return value !== undefined && value.S !== "" ? value.S : undefined;
};

const getOptionalValueNumeric = (value) => {
  return value !== undefined && value.N !== undefined
    ? Number(value.N)
    : undefined;
};

export const buildMeasurementFromDynamoDbRecord = (element) => {
  console.log("element:", element);
  return {
    userId: element.UserId.S,
    measurementId: element.MeasurementId.S,
    timestamp: Number(element.Timestamp.N),
    date: Number(element.Date.N),
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
      MeasurementId: { S: "" + measurementId },
    },
  };
};

export const retrieveAllMeasurements = async (region, tableName, userId) => {
  const params = buildDynamoDbParamsRetrieveAllMeasurements(tableName, userId);
  console.log("params:", params);

  const ddbClient = new DynamoDBClient({ region: region });
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
  region,
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

  const ddbClient = new DynamoDBClient({ region: region });
  const retrievedData = await ddbClient.send(new GetItemCommand(params));
  const measurements = [];

  if (retrievedData.Item != null) {
    measurements.push(buildMeasurementFromDynamoDbRecord(retrievedData.Item));
  }

  return measurements;
};
