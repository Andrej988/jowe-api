"use strict";

import { PutItemCommand } from "@aws-sdk/client-dynamodb";
import { randomUUID } from "node:crypto";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
import { retrieveSingleTargetWeight } from "/opt/nodejs/targets/utils.mjs";

const buildRecord = (tableName, userId, recordId, targetWeight) => {
  return {
    TableName: tableName,
    Item: {
      UserId: {
        S: userId,
      },
      RecordId: {
        S: recordId,
      },
      Timestamp: {
        N: "" + Date.now(),
      },
      TargetWeight: {
        N: "" + targetWeight,
      },
      LastModified: {
        N: "" + Date.now(),
      },
    },
    ReturnValues: "ALL_OLD",
  };
};

const validateTargetWeight = (targetWeight) => {
  if (!targetWeight) {
    throw new Error("Target weight must be provided.");
  }

  if (isNaN(targetWeight) || targetWeight < 0 || targetWeight > 999) {
    throw new Error("Invalid target weight value (0-999).");
  }
};

export const handler = async (event, context) => {
  const tableName = process.env.TABLE_NAME;
  const userId = event.userId;
  const recordId = randomUUID();
  const targetWeight = event.targetWeight;

  console.info("data", {
    tableName: tableName,
    userId: userId,
    recordId: recordId,
    targetWeight: targetWeight,
  });

  let response;

  try {
    validateTargetWeight(targetWeight);
  } catch (err) {
    console.error("Validation error:", err.message);

    response = buildErrorResponse(400, err.message);
    context.fail(JSON.stringify(response));
  }

  try {
    const targetWeightDataDynamoDb = buildRecord(
      tableName,
      userId,
      recordId,
      targetWeight
    );
    const dynamoDbMetadata = await ddbClient.send(
      new PutItemCommand(targetWeightDataDynamoDb)
    );
    console.info(dynamoDbMetadata);

    const retrievedTargetWeight = await retrieveSingleTargetWeight(
      tableName,
      userId,
      recordId
    );

    const responseBody = {
      recordId: recordId,
      targetWeight: retrievedTargetWeight,
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
