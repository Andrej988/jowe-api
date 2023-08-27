"use strict";

// Retrieved from lambda layers
import { buildResponse, buildErrorResponse } from "/opt/nodejs/reqResUtils.mjs";
import {
  retrieveSingleRecipe,
  retrieveAllRecipes,
} from "/opt/nodejs/recipes/utils.mjs";

export const handler = async (event) => {
  console.info("event", event);
  const type = event.type;
  const tableName = process.env.TABLE_NAME;

  const userId = event.userId;
  const recipeId = event.recipeId;
  console.info("UserId:", userId);
  console.info("RecipeId:", recipeId);

  let response;

  try {
    if (type === "all") {
      const recipes = await retrieveAllRecipes(tableName, userId);
      const responseBody = {
        recipes: recipes,
      };
      response = buildResponse(200, responseBody);
      console.info("response", response);
      return response;
    } else if (type === "single") {
      const recipe = await retrieveSingleRecipe(tableName, userId, recipeId);

      response = buildResponse(200, recipe);
      console.info("response", response);
      return response;
    } else {
      response = buildErrorResponse(400, "Wrong query type!");
      context.fail(JSON.stringify(response));
    }
  } catch (err) {
    console.error(err);
    response = buildErrorResponse(500, err.message);
    context.fail(JSON.stringify(response));
  }
};
