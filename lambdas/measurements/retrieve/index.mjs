import {
  DynamoDBClient,
  GetItemCommand,
  QueryCommand,
} from "@aws-sdk/client-dynamodb";

const REGION = process.env.AWS_REGION;
const ddbClient = new DynamoDBClient({ region: REGION });

const buildParamsAll = (tableName, userId) => {
  return {
    TableName: tableName,
    KeyConditionExpression: "UserId = :userId",
    ExpressionAttributeValues: {
      ":userId": { S: userId },
    },
  };
};

const buildParamsSingle = (tableName, userId, measurementId) => {
  return {
    TableName: tableName,
    Key: {
      UserId: { S: userId },
      MeasurementId: { S: "" + measurementId },
    },
  };
};

const getOptionalValueString = (value) => {
  return value !== undefined && value.S !== "" ? value.S : undefined;
};

const getOptionalValueNumeric = (value) => {
  return value !== undefined && value.N !== undefined
    ? Number(value.N)
    : undefined;
};

const buildMeasurement = (element) => {
  console.log("element:", element);
  return {
    userId: element.UserId.S,
    measurementId: element.MeasurementId.S,
    timestamp: Number(element.Timestamp.N),
    date: Number(element.Date.N),
    note: getOptionalValueString(element.Note),
    measurements: {
      weight: Number(element.Weight.N),
      bodyFatPercentage: getOptionalValueNumeric(element.BodyFatPercentage),
      waterPercentage: getOptionalValueNumeric(element.WaterPercentage),
      muscleMassPercentage: getOptionalValueNumeric(
        element.MuscleMassPercentage
      ),
      bonePercentage: getOptionalValueNumeric(element.BonePercentage),
      energyExpenditure: getOptionalValueNumeric(element.EnergyExpenditure),
    },
  };
};

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
  let measurements = [];

  if (type === "all") {
    const params = buildParamsAll(tableName, userId);
    console.log("params:", params);

    try {
      const measurementsData = await ddbClient.send(new QueryCommand(params));
      measurementsData.Items.forEach((row) => {
        measurements.push(buildMeasurement(row));
      });

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
  } else if (type === "single") {
    const params = buildParamsSingle(tableName, userId, measurementId);
    console.log("params:", params);

    const measurementData = await ddbClient.send(new GetItemCommand(params));
    console.log("Success", measurementData.Item);
    if (measurementData.Item != null) {
      measurements.push(buildMeasurement(measurementData.Item));
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
