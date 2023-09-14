"use strict";

import { GetItemCommand, QueryCommand } from "@aws-sdk/client-dynamodb";

import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";

import { getOptionalValueString } from "/opt/nodejs/utils.mjs";

export const buildRecipeFromDynamoDbRecord = (element) => {
  console.log("element:", element);
  return {
    userId: element.UserId.S,
    recipeId: element.RecipeId.S,
    name: element.Name.S,
    ingredients: element.Ingredients.S,
    servingSize: getOptionalValueString(element.ServingSize),
    preparation: element.Preparation.S,
    notes: getOptionalValueString(element.Notes),
    preparationTime: Number(element.PreparationTime.N),
    favorite: element.Favorite.BOOL,
    created: Number(element.Created.N),
    lastModified: Number(element.LastModified.N),
  };
};

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
  recipeId
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
