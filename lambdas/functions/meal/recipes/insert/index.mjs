"use strict";

import { PutItemCommand } from "@aws-sdk/client-dynamodb";
import { randomUUID } from "node:crypto";

import { validateRecipe } from "./validation.mjs";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
import { retrieveSingleRecipe } from "/opt/nodejs/recipes/utils.mjs";

export const buildRecipe = (tableName, recipe) => {
  return {
    TableName: tableName,
    Item: {
      UserId: {
        S: recipe.userId,
      },
      RecipeId: {
        S: recipe.recipeId,
      },
      Name: {
        S: recipe.name,
      },
      Ingredients: {
        S: JSON.stringify(recipe.ingredients),
      },
      ServingSize: {
        S: recipe.servingSize,
      },
      Preparation: {
        S: recipe.preparation,
      },
      PreparationTime: {
        N: "" + recipe.preparationTime,
      },
      Notes: {
        S: recipe.notes,
      },
      Favorite: {
        BOOL: recipe.favorite,
      },
      Created: {
        N: "" + Date.now(),
      },
      LastModified: {
        N: "" + Date.now(),
      },
    },
    ReturnValues: "ALL_OLD",
  };
};

export const handler = async (event, context) => {
  console.info("recipe: ", event.recipe);
  console.info("userId: ", event.recipe.userId);

  const tableName = process.env.TABLE_NAME;

  const recipe = {
    userId: event.recipe.userId,
    recipeId: randomUUID(),
    name: event.recipe.name,
    ingredients: event.recipe.ingredients,
    servingSize: event.recipe.servingSize,
    preparation: event.recipe.preparation,
    preparationTime: event.recipe.preparationTime,
    notes: event.recipe.notes,
    favorite: event.recipe.favorite,
  };

  let response;

  try {
    validateRecipe(recipe);
  } catch (err) {
    console.error("Validation error:", err.message);

    response = buildErrorResponse(400, err.message);
    context.fail(JSON.stringify(response));
  }

  try {
    const recipeDataDynamoDb = buildRecipe(tableName, recipe);
    const data = await ddbClient.send(new PutItemCommand(recipeDataDynamoDb));
    console.info(data);

    const retrievedRecipe = await retrieveSingleRecipe(
      tableName,
      recipe.userId,
      recipe.recipeId
    );

    console.log(retrievedRecipe);

    const responseBody = {
      recipeId: recipe.recipeId,
      recipe: retrievedRecipe,
    };
    response = buildResponse(200, responseBody);

    console.info("response", response);
    return response;
  } catch (err) {
    console.error("Error while processing:", err);

    response = buildErrorResponse(500, err.message);
    context.fail(JSON.stringify(response));
  }
};
