resource "aws_api_gateway_model" "meal_recipes_insert_request" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "MealRecipesInsertRequestSchema"
  description  = "Meal Recipe Insert Request Data"
  content_type = "application/json"

  schema = file("./models/meal/recipes/MealRecipesInsertRequestSchema.json")
}

resource "aws_api_gateway_model" "meal_recipes_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "MealRecipesResponseSchema"
  description  = "Meal recipes Response Data"
  content_type = "application/json"

  schema = file("./models/meal/recipes/MealRecipesResponseSchema.json")
}

resource "aws_api_gateway_model" "meal_recipe_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "MealRecipeResponseSchema"
  description  = "Meal recipe Response Data"
  content_type = "application/json"

  schema = file("./models/meal/recipes/MealRecipeResponseSchema.json")
}
