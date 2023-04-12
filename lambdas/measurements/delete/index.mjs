import { DynamoDBClient, DeleteItemCommand } from "@aws-sdk/client-dynamodb";

const REGION = process.env.AWS_REGION;
const ddbClient = new DynamoDBClient({ region: REGION });

export const handler = async (event) => {
  const params = {
    TableName: "weight-tracker",
    Key: {
      UserId: { S: event.userId },
      MeasurementId: { S: "" + event.measurementId },
    },
  };

  let response;

  try {
    const data = await ddbClient.send(new DeleteItemCommand(params));
    console.log("Success, item deleted", data);
    response = {
      statusCode: 200,
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
