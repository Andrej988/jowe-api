"use strict";

export const buildResponse = (statusCode, body) => {
  return {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  };
};

export const buildErrorResponse = (statusCode, errorText) => {
  return {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json",
    },
    body: {
      error: errorText,
    },
  };
};
