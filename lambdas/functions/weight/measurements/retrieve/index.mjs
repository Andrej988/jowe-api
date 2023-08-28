"use strict";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import {
  retrieveSingleMeasurement,
  retrieveAllMeasurements,
} from "/opt/nodejs/measurements/utils.mjs";

export const handler = async (event, context) => {
  console.info("event", event);
  const type = event.type;
  const tableName = process.env.TABLE_NAME;

  const userId = event.userId;
  const measurementId = event.measurementId;
  console.info("UserId:", userId);
  console.info("MeasurementId:", measurementId);

  let response;

  try {
    if (type === "all") {
      const measurements = await retrieveAllMeasurements(tableName, userId);
      const responseBody = {
        measurements: measurements,
      };
      response = buildResponse(200, responseBody);
      console.info("response", response);
      return response;
    } else if (type === "single") {
      const measurement = await retrieveSingleMeasurement(
        tableName,
        userId,
        measurementId
      );

      response = buildResponse(200, measurement);
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
