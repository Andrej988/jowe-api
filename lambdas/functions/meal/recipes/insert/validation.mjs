"use strict";

export const validateRecipe = (recipe) => {
  console.log("validation of recipe", recipe);

  validateName(recipe.name);
  validateIngredients(recipe.ingredients);
  validatePreparation(recipe.preparation);
  validatePreparationTime(recipe.preparationTime);
};

const validateName = (value) => {
  if (value.length === 0) {
    throw new Error("Name of recipe should be provided!");
  }
};

const validateIngredients = (value) => {
  if (value.length === 0) {
    throw new Error("Ingredients of recipe should be provided!");
  }
};

const validatePreparation = (value) => {
  if (value.length === 0) {
    throw new Error("Preparation of recipe should be provided!");
  }
};

const validatePreparationTime = (value) => {
  if (value < 0 || value > 720) {
    throw new Error("Preparation time should be between 1-720 minutes!");
  }
};
