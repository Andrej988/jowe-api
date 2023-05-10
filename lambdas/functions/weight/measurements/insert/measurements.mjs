"use strict";

export const buildMeasurement = (tableName, measurement) => {
  const measurementDynamoDb = {
    TableName: tableName,
    Item: {
      UserId: {
        S: measurement.userId,
      },
      MeasurementId: {
        S: measurement.measurementId,
      },
      Timestamp: {
        N: "" + Date.now(),
      },
      Date: {
        N: "" + measurement.date,
      },
      Weight: {
        N: "" + measurement.weight,
      },
    },
  };

  addOptionalFieldsToMeasurement(measurementDynamoDb, measurement);
  return measurementDynamoDb;
};

const addOptionalFieldsToMeasurement = (measurementDynamoDb, measurement) => {
  if (measurement.note) {
    measurementDynamoDb.Item.Note = {
      S: measurement.note,
    };
  }

  if (measurement.bodyFatPercentage) {
    measurementDynamoDb.Item.BodyFatPercentage = {
      N: "" + measurement.bodyFatPercentage,
    };
  }

  if (measurement.waterPercentage) {
    measurementDynamoDb.Item.WaterPercentage = {
      N: "" + measurement.waterPercentage,
    };
  }

  if (measurement.muscleMassPercentage) {
    measurementDynamoDb.Item.MuscleMassPercentage = {
      N: "" + measurement.muscleMassPercentage,
    };
  }

  if (measurement.bonePercentage) {
    measurementDynamoDb.Item.BonePercentage = {
      N: "" + measurement.bonePercentage,
    };
  }

  if (measurement.energyExpenditure) {
    measurementDynamoDb.Item.EnergyExpenditure = {
      N: "" + measurement.energyExpenditure,
    };
  }
};
