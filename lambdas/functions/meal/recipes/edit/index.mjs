"use strict";

import { UpdateItemCommand } from "@aws-sdk/client-dynamodb";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import { ddbClient } from "/opt/nodejs/dynamodb/client.mjs";
import { buildRecipeFromDynamoDbRecord } from "/opt/nodejs/recipes/utils.mjs";

export const handler = async (event, context) => {
  console.info("recipe: ", event.recipe);
  console.info("userId: ", event.recipe.userId);

  const tableName = process.env.TABLE_NAME;

  const recipe = {
    userId: event.recipe.userId,
    recipeId: event.recipe.recipeId,
    name: event.recipe.name,
    ingredients: event.recipe.ingredients,
    preparation: event.recipe.preparation,
    preparationTime: event.recipe.preparationTime,
  };

  const params = {
    TableName: tableName,
    Key: {
      UserId: { S: recipe.userId },
      RecipeId: { S: recipe.recipeId },
    },
    UpdateExpression:
      "set #name = :name, Ingredients = :ingredients, Preparation = :preparation, PreparationTime = :preparationTime, LastModified = :lastModified",
    ExpressionAttributeNames: {
      "#name": "Name",
    },
    ExpressionAttributeValues: {
      ":name": {
        S: "" + recipe.name,
      },
      ":ingredients": {
        S: "" + recipe.ingredients,
      },
      ":preparation": {
        S: "" + recipe.preparation,
      },
      ":preparationTime": {
        N: "" + recipe.preparationTime,
      },
      ":lastModified": {
        N: "" + Date.now(),
      },
    },
    ReturnValues: "ALL_NEW",
  };
  console.log("params", params);

  let response;

  try {
    const data = await ddbClient.send(new UpdateItemCommand(params));
    console.info("Success, item edited", data);

    const retrievedRecipe = buildRecipeFromDynamoDbRecord(data.Attributes);
    console.log(retrievedRecipe);

    const responseBody = {
      recipe: retrievedRecipe,
    };
    response = buildResponse(200, responseBody);

    console.info("response", response);
    return response;
  } catch (err) {
    console.error(err);
    response = buildErrorResponse(500, err.message);
    context.fail(JSON.stringify(response));
  }
};
