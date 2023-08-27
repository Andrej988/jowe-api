"use strict";

import { GetItemCommand, QueryCommand } from "@aws-sdk/client-dynamodb";

import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
/*import {
  getOptionalValueString,
  getOptionalValueNumeric,
} from "/opt/nodejs/utils.mjs";*/

export const buildRecipeFromDynamoDbRecord = (element) => {
  console.log("element:", element);
  return {
    userId: element.UserId.S,
    recipeId: element.RecipeId.S,
    name: element.Name.S,
    ingredients: element.Ingredients.S,
    preparation: element.Preparation.S,
    preparationTime: Number(element.PreparationTime.N),
    created: Number(element.Created.N),
    lastModified: Number(element.LastModified.N),
  };
};

/*export const buildRecipeFromReturnValues = (attributes) => {
  console.log("Attributes:", attributes);
  return {
    userId: attributes.UserId.S,
    measurementId: attributes.MeasurementId.S,
    timestamp: Number(attributes.Timestamp.N),
    date: Number(attributes.MeasurementDate.N),
    note: getOptionalValueString(attributes.Note),
    lastModified: getOptionalValueNumeric(attributes.LastModified),
    measurements: {
      weight: Number(attributes.Weight.N),
      bodyFatPercentage: getOptionalValueNumeric(attributes.BodyFatPercentage),
      waterPercentage: getOptionalValueNumeric(attributes.WaterPercentage),
      muscleMassPercentage: getOptionalValueNumeric(
        attributes.MuscleMassPercentage
      ),
      bonePercentage: getOptionalValueNumeric(attributes.BonePercentage),
      energyExpenditure: getOptionalValueNumeric(attributes.EnergyExpenditure),
    },
  };
};*/

export const buildDynamoDbParamsRetrieveAllRecipes = (tableName, userId) => {
  return {
    TableName: tableName,
    KeyConditionExpression: "UserId = :userId",
    ExpressionAttributeValues: {
      ":userId": { S: userId },
    },
  };
};

export const buildDynamoDbParamsRetrieveSingleRecipe = (
  tableName,
  userId,
  measurementId
) => {
  return {
    TableName: tableName,
    Key: {
      UserId: { S: userId },
      RecipeId: { S: recipeId },
    },
  };
};

export const retrieveAllRecipes = async (tableName, userId) => {
  const params = buildDynamoDbParamsRetrieveAllRecipes(tableName, userId);
  console.log("params:", params);

  const retrievedData = await ddbClient.send(new QueryCommand(params));
  const recipes = [];

  if (retrievedData.Items != null) {
    retrievedData.Items.forEach((record) => {
      recipes.push(buildRecipeFromDynamoDbRecord(record));
    });
  }

  return recipes;
};

export const retrieveSingleRecipe = async (tableName, userId, recipeId) => {
  const params = buildDynamoDbParamsRetrieveSingleRecipe(
    tableName,
    userId,
    recipeId
  );
  console.log("params:", params);

  const retrievedData = await ddbClient.send(new GetItemCommand(params));
  let recipe;

  if (retrievedData.Item != null) {
    recipe = buildRecipeFromDynamoDbRecord(retrievedData.Item);
  }

  return recipe;
};
