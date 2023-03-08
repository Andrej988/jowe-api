import {
  DynamoDBClient,
  GetItemCommand,
  ScanCommand,
} from "@aws-sdk/client-dynamodb";

const REGION = "eu-south-1";
const ddbClient = new DynamoDBClient({ region: REGION });

export const handler = async (event) => {
  const tableName = "weight-tracker";
  console.log("UserId:", event.UserId);
  console.log("MeasurementId:", event.MeasurementId);

  let response;
  let measurements = [];

  const mappingFunction = (element) => {
    const measurement = {
      userId: element.UserId.S,
      measurementId: element.MeasurementId.S,
      timestamp: Number(element.Timestamp.N),
      date: element.Date.S,
      comment: element.Comment.S,
      measurements: {
        weight: Number(element.Weight.N),
        bodyFatPercentage: Number(element.BodyFatPercentage.N),
        waterPercentage: Number(element.WaterPercentage.N),
        muscleMassPercentage: Number(element.MuscleMassPercentage.N),
        bonePercentage: Number(element.BonePercentage.N),
        energyExpenditure: Number(element.EnergyExpenditure.N),
      },
    };
    measurements.push(measurement);
  };

  if (event.type === "all") {
    const params = {
      TableName: tableName,
      FilterExpression: "UserId = :userId",
      ExpressionAttributeValues: {
        ":userId": { S: event.UserId },
      },
    };

    try {
      const measurementsData = await ddbClient.send(new ScanCommand(params));
      measurementsData.Items.forEach(mappingFunction);

      response = {
        statusCode: 200,
        measurements: measurements,
      };
    } catch (err) {
      console.error(err);
      response = {
        statusCode: 500,
        body: JSON.stringify(err),
      };
    }
  } else if (event.type === "single") {
    const params = {
      TableName: tableName,
      Key: {
        UserId: { S: event.UserId },
        MeasurementId: { S: "" + event.measurementId },
      },
    };

    const measurementData = await ddbClient.send(new GetItemCommand(params));
    console.log("Success", measurementData.Item);
    if (measurementData.Item != null) {
      mappingFunction(measurementData.Item);
    }

    response = {
      statusCode: 200,
      measurements: measurements,
    };
  } else {
    response = {
      statusCode: 404,
      body: JSON.stringify("Error: Wrong query type!"),
    };
  }

  return response;
};
