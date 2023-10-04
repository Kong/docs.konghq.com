function getMessageFromError(error) {
  if (!error) {
    return error;
  }

  if (error && error.response && error.response.data) {
    if (error.response.data.message) {
      return error.response.data.message;
    }

    if (typeof error.response.data === "string") {
      return error.response.data;
    }

    if (typeof error.response.data === "object") {
      return Object.keys(error.response.data)
        .map(key => `${key} ${error.response.data[key]}`)
        .join(", ");
    }
  }

  return error.message || "There was an error";
}

export default getMessageFromError
