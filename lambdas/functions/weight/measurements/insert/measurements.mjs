"use strict";

export const buildMeasurement = (
  tableName,
  userId,
  measurementId,
  date,
  weight,
  note,
  bodyFatPercentage,
  waterPercentage,
  muscleMassPercentage,
  bonePercentage,
  energyExpenditure
) => {
  const measurement = {
    TableName: tableName,
    Item: {
      UserId: {
        S: userId,
      },
      MeasurementId: {
        S: measurementId,
      },
      Timestamp: {
        N: "" + Date.now(),
      },
      Date: {
        N: "" + date,
      },
      Weight: {
        N: "" + weight,
      },
    },
  };

  addOptionalFieldsToMeasurement(
    measurement,
    note,
    bodyFatPercentage,
    waterPercentage,
    muscleMassPercentage,
    bonePercentage,
    energyExpenditure
  );
  return measurement;
};

const addOptionalFieldsToMeasurement = (
  measurement,
  note,
  bodyFatPercentage,
  waterPercentage,
  muscleMassPercentage,
  bonePercentage,
  energyExpenditure
) => {
  if (note) {
    measurement.Item.Note = {
      S: note,
    };
  }

  if (bodyFatPercentage) {
    measurement.Item.BodyFatPercentage = {
      N: "" + bodyFatPercentage,
    };
  }

  if (waterPercentage) {
    measurement.Item.WaterPercentage = {
      N: "" + waterPercentage,
    };
  }

  if (muscleMassPercentage) {
    measurement.Item.MuscleMassPercentage = {
      N: "" + muscleMassPercentage,
    };
  }

  if (bonePercentage) {
    measurement.Item.BonePercentage = {
      N: "" + bonePercentage,
    };
  }

  if (energyExpenditure) {
    measurement.Item.EnergyExpenditure = {
      N: "" + energyExpenditure,
    };
  }
};

const test = "test";
