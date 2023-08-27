import { QueryCommand, BatchWriteItemCommand } from "@aws-sdk/client-dynamodb";

// Retrieved from lambda layers
import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
import { chunkArray } from "/opt/nodejs/utils.mjs";

export const buildParamsForQueryDataByUserId = (
  tableName,
  userId,
  sortKeyName
) => {
  return {
    TableName: tableName,
    KeyConditionExpression: "UserId = :userId",
    ExpressionAttributeValues: {
      ":userId": { S: userId },
    },
    ProjectionExpression: `UserId, ${sortKeyName}`,
  };
};

export const deleteUserData = async (
  tableName,
  queryParams,
  buildDeleteRequestFn
) => {
  console.log("start deletion");
  console.log("queryParams", queryParams);

  try {
    const queryResults = await ddbClient.send(new QueryCommand(queryParams));

    if (queryResults.Items && queryResults.Items.length > 0) {
      const batchCalls = chunkArray(queryResults.Items, 25).map(
        async (chunk) => {
          const deleteRequests = chunk.map((item) => {
            console.log("item", item);
            const deleteRequestObj = buildDeleteRequestFn(item);
            console.log("deleteRequestObj", deleteRequestObj);
            return deleteRequestObj;
          });

          const batchWriteParams = {
            RequestItems: {
              [tableName]: deleteRequests,
            },
          };
          console.log("batchWriteParams", batchWriteParams);
          await ddbClient.send(new BatchWriteItemCommand(batchWriteParams));
        }
      );

      await Promise.all(batchCalls);
    }
  } catch (err) {
    console.error(err);
  }
};

export const addOptionalStringParam = (params, key, value) => {
  if (value) {
    params.ExpressionAttributeValues[key] = { S: value };
  } else {
    params.ExpressionAttributeValues[key] = { NULL: true };
  }
};

export const addOptionalNumericParam = (params, key, value) => {
  if (value) {
    params.ExpressionAttributeValues[key] = { N: "" + value };
  } else {
    params.ExpressionAttributeValues[key] = { NULL: true };
  }
};
