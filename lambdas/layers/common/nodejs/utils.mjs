export const chunkArray = (inputArray, itemsPerChunk) => {
  return inputArray.reduce((all, one, i) => {
    const ch = Math.floor(i / itemsPerChunk);
    all[ch] = [].concat(all[ch] || [], one);
    return all;
  }, []);
};

export const getOptionalValueString = (value) => {
  return value !== undefined && value.S !== "" ? value.S : undefined;
};

export const getOptionalValueNumeric = (value) => {
  return value !== undefined && value.N !== undefined
    ? Number(value.N)
    : undefined;
};
