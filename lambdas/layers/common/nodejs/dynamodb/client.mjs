import { DynamoDBClient } from "@aws-sdk/client-dynamodb";

const REGION = process.env.AWS_REGION;
export const ddbClient = new DynamoDBClient({ region: REGION });
