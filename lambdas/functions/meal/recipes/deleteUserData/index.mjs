"use strict";

import { DeleteMessageCommand, SQSClient } from "@aws-sdk/client-sqs";

// Retrieved from lambda layers
import {
  buildParamsForQueryDataByUserId,
  deleteUserData,
} from "/opt/nodejs/dynamodb/utils.mjs";
import { receiveMessage } from "/opt/nodejs/sqs/utils.mjs";

const buildDeleteRequest = (item) => {
  return {
    DeleteRequest: {
      Key: {
        UserId: item.UserId,
        RecipeId: item.RecipeId,
      },
    },
  };
};

export const handler = async (event, context) => {
  console.log("event", event);

  const SQS_QUEUE_URL = process.env.SQS_QUEUE_URL;
  const TABLE_NAME = process.env.TABLE_NAME;
  console.log("SQS_QUEUE_URL: ", SQS_QUEUE_URL);
  console.log("TABLE_NAME: ", TABLE_NAME);

  const client = new SQSClient({});
  const { Messages } = await receiveMessage(client, SQS_QUEUE_URL);

  if (Messages) {
    for (const msg of Messages) {
      console.log("msg: ", msg);
      const bodyJson = JSON.parse(msg.Body);
      const userId = bodyJson.Message;
      console.log("User ID: ", userId);

      if (userId && userId !== "") {
        const queryParams = buildParamsForQueryDataByUserId(
          TABLE_NAME,
          userId,
          "RecipeId"
        );

        await deleteUserData(TABLE_NAME, queryParams, buildDeleteRequest);
      }

      await client.send(
        new DeleteMessageCommand({
          QueueUrl: SQS_QUEUE_URL,
          ReceiptHandle: msg.ReceiptHandle,
        })
      );
    }
  }
};
