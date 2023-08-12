"use strict";

import { GetItemCommand, QueryCommand } from "@aws-sdk/client-dynamodb";

import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";

export const buildTargetWeightFromDynamoDbRecord = (element) => {
  console.log("element:", element);
  return {
    userId: element.UserId.S,
    recordId: element.RecordId.S,
    timestamp: Number(element.Timestamp.N),
    targetWeight: Number(element.TargetWeight.N),
    lastModified: Number(element.LastModified.N),
  };
};

export const buildDynamoDbParamsRetrieveAllTargetWeights = (
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

export const buildDynamoDbParamsRetrieveSingleTargetWeight = (
  tableName,
  userId,
  recordId
) => {
  return {
    TableName: tableName,
    Key: {
      UserId: { S: userId },
      RecordId: { S: recordId },
    },
  };
};

export const retrieveAllTargetWeights = async (tableName, userId) => {
  const params = buildDynamoDbParamsRetrieveAllTargetWeights(tableName, userId);
  console.log("params:", params);

  const retrievedData = await ddbClient.send(new QueryCommand(params));
  const targets = [];

  if (retrievedData.Items != null) {
    retrievedData.Items.forEach((record) => {
      targets.push(buildTargetWeightFromDynamoDbRecord(record));
    });
  }

  return targets;
};

export const retrieveSingleTargetWeight = async (
  tableName,
  userId,
  recordId
) => {
  const params = buildDynamoDbParamsRetrieveSingleTargetWeight(
    tableName,
    userId,
    recordId
  );
  console.log("params:", params);

  const retrievedData = await ddbClient.send(new GetItemCommand(params));
  let targetWeight;

  if (retrievedData.Item != null) {
    targetWeight = buildTargetWeightFromDynamoDbRecord(retrievedData.Item);
  }

  return targetWeight;
};
