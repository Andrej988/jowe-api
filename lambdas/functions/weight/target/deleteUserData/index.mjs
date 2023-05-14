"use strict";

// Retrieved from lambda layers
import {
  buildParamsForQueryDataByUserId,
  deleteUserData,
} from "/opt/nodejs/dynamodb/utils.mjs";

const buildDeleteRequest = (item) => {
  return {
    DeleteRequest: {
      Key: {
        UserId: item.UserId,
        RecordId: item.RecordId,
      },
    },
  };
};

export const handler = async (event) => {
  console.log("event", event);

  const tableName = process.env.TABLE_NAME;
  console.log("tableName: ", tableName);

  if (event.Records.length > 0) {
    for (const record of event.Records) {
      const body = JSON.parse(record.body);
      const userId = body.Message;
      console.log("User ID: ", userId);

      if (userId && userId !== "") {
        const queryParams = buildParamsForQueryDataByUserId(
          tableName,
          userId,
          "RecordId"
        );

        await deleteUserData(tableName, queryParams, buildDeleteRequest);
      }
    }
  }
};
