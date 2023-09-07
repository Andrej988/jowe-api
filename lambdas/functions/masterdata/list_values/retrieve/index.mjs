"use strict";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { retrieveListValues } from "/opt/nodejs/listValuesUtils.mjs";

export const handler = async (event, context) => {
  console.info("event", event);
  const tableName = process.env.TABLE_NAME;

  const listId = event.listId;
  console.info("ListId:", listId);

  let response;

  try {
    const values = await retrieveListValues(tableName, listId);
    const responseBody = {
      values: values,
    };
    response = buildResponse(200, responseBody);
    console.info("response", response);
    return response;
  } catch (err) {
    console.error(err);
    response = buildErrorResponse(500, err.message);
    context.fail(JSON.stringify(response));
  }
};
