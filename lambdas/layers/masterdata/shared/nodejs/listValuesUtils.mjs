"use strict";

import { QueryCommand } from "@aws-sdk/client-dynamodb";

import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
import { getOptionalValueStringSet } from "/opt/nodejs/utils.mjs";

export const buildListValueFromDynamoDbRecord = (element) => {
  console.log("element:", element);
  return {
    value: element.Value.S,
    stringSet1: getOptionalValueStringSet(element.StringSet1),
    stringSet2: getOptionalValueStringSet(element.StringSet2),
  };
};

export const buildDynamoDbParams = (tableName, listId) => {
  return {
    TableName: tableName,
    KeyConditionExpression: "ListId = :listId",
    ExpressionAttributeValues: {
      ":listId": { S: listId },
    },
  };
};

export const retrieveListValues = async (tableName, listId) => {
  const params = buildDynamoDbParams(tableName, listId);
  console.log("params:", params);

  const retrievedData = await ddbClient.send(new QueryCommand(params));
  const values = [];

  if (retrievedData.Items != null) {
    retrievedData.Items.forEach((record) => {
      values.push(buildListValueFromDynamoDbRecord(record));
    });
  }

  return values;
};
