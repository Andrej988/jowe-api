import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { randomUUID } from "node:crypto";

const REGION = process.env.AWS_REGION;
const ddbClient = new DynamoDBClient({ region: REGION });

const buildResponse = (measurementId, measurementData) => {
  return {
    statusCode: 201,
    headers: {
      "Content-Type": "application/json",
    },
    measurementId: measurementId,
    body: measurementData,
  };
};

const buildErrorResponse = (statusCode, errorText) => {
  return {
    statusCode: statusCode,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Origin": "'*'",
      "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
    },
    body: errorText,
  };
};

export const handler = async (event, context) => {
  console.log("measurement: ", event.measurement);
  console.log("table name: ", process.env.TABLE_NAME);
  console.log("userId: ", event.measurement.userId);

  const userId = event.measurement.userId;
  const measurementId = randomUUID();
  const date = event.measurement.date;
  const note = event.measurement.note;
  const weight = event.measurement.measurements.weight;
  const bodyFatPercentage = event.measurement.measurements.bodyFatPercentage;
  const waterPercentage = event.measurement.measurements.waterPercentage;
  const muscleMassPercentage =
    event.measurement.measurements.muscleMassPercentage;
  const bonePercentage = event.measurement.measurements.bonePercentage;
  const energyExpenditure = event.measurement.measurements.energyExpenditure;

  const measurement = {
    TableName: process.env.TABLE_NAME,
    Item: {
      UserId: {
        S: userId,
      },
      MeasurementId: {
        S: measurementId,
      },
      Timestamp: {
        N: "" + Date.now(),
      },
      Date: {
        S: date,
      },
      Weight: {
        N: "" + weight,
      },
    },
  };

  if (note) {
    measurement.Item.Note = {
      S: note,
    };
  }

  if (bodyFatPercentage) {
    measurement.Item.BodyFatPercentage = {
      N: "" + bodyFatPercentage,
    };
  }

  if (waterPercentage) {
    measurement.Item.WaterPercentage = {
      N: "" + waterPercentage,
    };
  }

  if (muscleMassPercentage) {
    measurement.Item.MuscleMassPercentage = {
      N: "" + muscleMassPercentage,
    };
  }

  if (bonePercentage) {
    measurement.Item.BonePercentage = {
      N: "" + bonePercentage,
    };
  }

  if (energyExpenditure) {
    measurement.Item.EnergyExpenditure = {
      N: "" + energyExpenditure,
    };
  }

  let response;

  try {
    const measurementData = await ddbClient.send(
      new PutItemCommand(measurement)
    );
    console.log(measurementData);
    response = buildResponse(measurementId, measurementData);
  } catch (err) {
    console.error(err);

    response = buildErrorResponse(500, err);
    context.fail(JSON.stringify(response));
  }

  return response;
};
