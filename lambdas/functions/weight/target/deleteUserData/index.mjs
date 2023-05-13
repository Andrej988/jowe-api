"use strict";

export const handler = async (event) => {
  console.log("event", event);

  if (event.Records.length > 0) {
    event.Records.forEach((record) => {
      const body = JSON.parse(record.body);
      const userId = body.Message;
      console.log("User ID: ", userId);
    });
  }
};
