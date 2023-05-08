"use strict";

import { DynamoDBClient, DeleteItemCommand } from "@aws-sdk/client-dynamodb";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";

const REGION = process.env.AWS_REGION;
const ddbClient = new DynamoDBClient({ region: REGION });

export const handler = async (event) => {
  const params = {
    TableName: process.env.TABLE_NAME,
    Key: {
      UserId: { S: event.userId },
      MeasurementId: { S: "" + event.measurementId },
    },
  };

  let response;

  try {
    const data = await ddbClient.send(new DeleteItemCommand(params));
    console.log("Success, item deleted", data);
    response = buildResponse(200, {});
    return response;
  } catch (err) {
    console.error(err);
    response = buildErrorResponse(500, err);
    context.fail(JSON.stringify(response));
  }
};
