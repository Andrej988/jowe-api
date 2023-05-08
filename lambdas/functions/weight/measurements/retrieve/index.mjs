"use strict";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import {
  retrieveSingleMeasurement,
  retrieveAllMeasurements,
} from "/opt/nodejs/measurementUtils.mjs";

const REGION = process.env.AWS_REGION;

export const handler = async (event) => {
  console.log("event", event);
  const type = event.type;
  const tableName = process.env.TABLE_NAME;
  const userId = event.userId;
  const measurementId = event.measurementId;

  console.log("tableName:", tableName);
  console.log("UserId:", userId);
  console.log("MeasurementId:", measurementId);

  let response;

  try {
    if (type === "all") {
      const measurements = await retrieveAllMeasurements(
        REGION,
        tableName,
        userId
      );
      const responseBody = {
        measurements: measurements,
      };
      response = buildResponse(200, responseBody);
    } else if (type === "single") {
      const measurements = await retrieveSingleMeasurement(
        REGION,
        tableName,
        userId,
        measurementId
      );

      response = buildResponse(200, measurements);
    } else {
      response = buildErrorResponse(400, "Wrong query type!");
    }
  } catch (err) {
    console.error(err);
    response = buildErrorResponse(500, err);
  }

  console.log("response: ", response);
  return response;
};
