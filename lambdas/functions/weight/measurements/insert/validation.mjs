"use strict";

export const validateMeasurement = (measurement) => {
  console.log("validation of measurment", measurement);

  validateDate(measurement.measurementDate);
  validateWeight(measurement.weight);
  validateBodyFatPercentage(measurement.bodyFatPercentage);
  validateWaterPercentage(measurement.waterPercentage);
  validateMuscleMassPercentage(measurement.muscleMassPercentage);
  validateBoneMassPercentage(measurement.bonePercentage);
  validateEnergyExpenditure(measurement.energyExpenditure);
};

const validateDate = (date) => {
  if (!date || isNaN(date)) {
    throw new Error("Date of measurement should be provided.");
  }

  // Check if date is not in the future (allows up to 15 mins in the future)
  if (date > Date.now() + 15 * 60 * 1000) {
    throw new Error("Date of measurement should not be in the future.");
  }
};

const validateWeight = (weight) => {
  if (!weight) {
    throw new Error("Weight measurement should be provided.");
  }

  if (isNaN(weight) || weight < 0 || weight > 999) {
    throw new Error("Invalid weight measurement value (0-999).");
  }
};

const validateBodyFatPercentage = (bodyFatPercentage) => {
  if (bodyFatPercentage && !isValidPercentageStrict(bodyFatPercentage)) {
    throw new Error(
      "Body fat percentage should be a valid percentage (0-100%)."
    );
  }
};

const validateWaterPercentage = (waterPercentage) => {
  if (waterPercentage && !isValidPercentageStrict(waterPercentage)) {
    throw new Error("Water percentage should be a valid percentage (0-100%).");
  }
};

const validateMuscleMassPercentage = (muscleMassPercentage) => {
  if (muscleMassPercentage && !isValidPercentageStrict(muscleMassPercentage)) {
    throw new Error(
      "Muscle mass percentage should be a valid percentage (0-100%)."
    );
  }
};

const validateBoneMassPercentage = (bonePercentage) => {
  if (bonePercentage && !isValidPercentageStrict(bonePercentage)) {
    throw new Error(
      "Bone mass percentage should be a valid percentage (0-100%)."
    );
  }
};

const validateEnergyExpenditure = (energyExpenditure) => {
  if (
    energyExpenditure &&
    (isNaN(energyExpenditure) ||
      energyExpenditure < 0 ||
      energyExpenditure > 20000)
  ) {
    throw new Error("Energy expenditure is not valid (0-20000 kcal).");
  }
};

const isValidPercentageStrict = (value) => {
  return value > 0 && value < 100;
};
