expect.extend({
  toHaveText(received, expected) {
    const pass = received.text() === expected;
    return {
      message: () => `expected ${received} to have text ${expected}`,
      pass,
    };
  },

  toHaveTextAllowingWhitespace(received, expected) {
    const pass = received.text().trim() === expected;
    return {
      message: () => `expected ${received} to have text ${expected} (allowing whitespace)`,
      pass,
    };
  },

  toContainText(received, expected) {
    const pass = received.text().includes(expected);
    return {
      message: () => `expected ${received} to contain text ${expected}`,
      pass,
    };
  },

  toHaveCount(received, expected) {
    const pass = received.length === expected
    return {
      message: () => `expected ${received} to be ${expected}`,
      pass,
    };
  },
});