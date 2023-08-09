"use strict";

import { UpdateItemCommand } from "@aws-sdk/client-dynamodb";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";

export const handler = async (event) => {
  const params = {
    TableName: process.env.TABLE_NAME,
    Key: {
      UserId: { S: event.userId },
      MeasurementId: { S: event.measurementId },
    },
    UpdateExpression:
      "set Date = :date, Weight = :weight, LastModified = :lastModified, Note = :note, BodyFatPercentage = :bodyFat",
    ExpressionAttributeValues: {
      ":date": {
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
    response = buildResponse(200, {});
    console.info("response", response);
    return response;
  } catch (err) {
    console.error(err);
    response = buildErrorResponse(500, err.message);
    context.fail(JSON.stringify(response));
  }
};
