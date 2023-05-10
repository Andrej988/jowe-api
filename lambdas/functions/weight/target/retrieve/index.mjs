"use strict";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import {
  retrieveSingleTargetWeight,
  retrieveAllTargetWeights,
} from "/opt/nodejs/targetWeightUtils.mjs";

const REGION = process.env.AWS_REGION;

export const handler = async (event) => {
  console.info("event", event);

  const type = event.type;
  const tableName = process.env.TABLE_NAME;
  const userId = event.userId;
  const recordId = event.recordId;
  console.info("data", {
    type: type,
    tableName: tableName,
    userId: userId,
    recordId: recordId,
  });

  let response;

  try {
    if (type === "all") {
      const targets = await retrieveAllTargetWeights(REGION, tableName, userId);
      const responseBody = {
        targetWeights: targets,
      };
      response = buildResponse(200, responseBody);
      console.info("response", response);
      return response;
    } else if (type === "single") {
      const target = await retrieveSingleTargetWeight(
        REGION,
        tableName,
        userId,
        recordId
      );

      response = buildResponse(200, target);
      console.info("response", response);
      return response;
    } else {
      response = buildErrorResponse(400, "Wrong query type!");
      context.fail(JSON.stringify(response));
    }
  } catch (err) {
    console.error(err);
    response = buildErrorResponse(500, err.message);
    context.fail(JSON.stringify(response));
  }
};
