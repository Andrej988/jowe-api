import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb";
import { randomUUID } from "node:crypto";

const REGION = process.env.AWS_REGION;
const ddbClient = new DynamoDBClient({ region: REGION });

export const handler = async (event) => {
  const measurementId = randomUUID();

  const measurement = {
    TableName: "weight-tracker",
    Item: {
      UserId: {
        S: event.measurement.userId,
      },
      MeasurementId: {
        S: measurementId,
      },
      Timestamp: {
        N: "" + Date.now(),
      },
      Date: {
        S: event.measurement.date,
      },
      Comment: {
        S: event.measurement.comment,
      },
      Weight: {
        N: "" + event.measurement.measurements.weight,
      },
      BodyFatPercentage: {
        N: "" + event.measurement.measurements.bodyFatPercentage,
      },
      WaterPercentage: {
        N: "" + event.measurement.measurements.waterPercentage,
      },
      MuscleMassPercentage: {
        N: "" + event.measurement.measurements.muscleMassPercentage,
      },
      BonePercentage: {
        N: "" + event.measurement.measurements.bonePercentage,
      },
      EnergyExpenditure: {
        N: "" + event.measurement.measurements.energyExpenditure,
      },
    },
  };

  let response;

  try {
    const measurementData = await ddbClient.send(
      new PutItemCommand(measurement)
    );
    console.log(measurementData);
    response = {
      statusCode: 201,
      measurementId: measurementId,
      body: JSON.stringify(measurementData),
    };
  } catch (err) {
    console.error(err);
    response = {
      statusCode: 500,
      body: JSON.stringify(err),
    };
  }

  return response;
};
