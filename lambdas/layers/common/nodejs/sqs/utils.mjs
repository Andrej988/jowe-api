import { ReceiveMessageCommand } from "@aws-sdk/client-sqs";

export const receiveMessage = (client, queueUrl) =>
  client.send(
    new ReceiveMessageCommand({
      AttributeNames: ["SentTimestamp"],
      MaxNumberOfMessages: 5,
      MessageAttributeNames: ["All"],
      QueueUrl: queueUrl,
      VisibilityTimeout: 60,
      WaitTimeSeconds: 5,
    })
  );
