const fs = require('fs');
const yamlPreProcessor = require('../../src/pre-processors/yaml-files.js');

// Mock the fs.readFileSync function
jest.mock('fs');

describe('yamlPreProcessor', () => {
  const filePath = 'example.yaml';

  describe('plugin metadata file', () => {
    beforeEach(() => {
      fs.readFileSync.mockReturnValue(`
name: ACL
dbless_compatible: partially
dbless_explanation: |
  Consumers and ACLs can be created with declarative configuration.

  Admin API endpoints that POST, PUT, PATCH, or DELETE ACLs do not work in DB-less mode.
free: true
enterprise: true
`);
    });

    it('should process YAML and return output string', () => {
      const attributesToTranslate = ['desc', 'dbless_explanation'];
      const expectedOutput = `# smartling.sltrans = notranslate
name: ACL
dbless_compatible: partially
# smartling.sltrans = translate
dbless_explanation: |
  Consumers and ACLs can be created with declarative configuration.
  
  Admin API endpoints that POST, PUT, PATCH, or DELETE ACLs do not work in DB-less mode.
  
# smartling.sltrans = notranslate
free: true
enterprise: true
`;

      const output = yamlPreProcessor(filePath, attributesToTranslate);

      expect(output).toEqual(expectedOutput);
    });
  });

  describe('doc anv file', () => {
    beforeEach(() => {
      fs.readFileSync.mockReturnValue(`
product: gateway
release: 3.7.x
generate: true
assume_generated: true
items:
  - title: Introduction
    icon: /assets/images/icons/documentation/icn-flag.svg
    items:
      - text: Overview of Kong Gateway
        url: /gateway/3.7.x/
        absolute_url: true
      - text: Support
        items:
          - text: Version Support Policy
            url: /support-policy/
            src: /gateway/support/index
          - text: Third Party Dependencies
            url: /support/third-party
          - text: Browser Support
            url: /support/browser
          - text: Vulnerability Patching Process
            url: /support/vulnerability-patching-process
          - text: Software Bill of Materials
            url: /support/sbom
`);
    });

    it('should process YAML and return output string', () => {
      const attributesToTranslate = ['text', 'title'];
      const expectedOutput = `# smartling.sltrans = notranslate
product: gateway
release: 3.7.x
generate: true
assume_generated: true
items:
  -
    # smartling.sltrans = translate
    title: Introduction
    # smartling.sltrans = notranslate
    icon: /assets/images/icons/documentation/icn-flag.svg
    items:
      -
        # smartling.sltrans = translate
        text: Overview of Kong Gateway
        # smartling.sltrans = notranslate
        url: /gateway/3.7.x/
        absolute_url: true
      -
        # smartling.sltrans = translate
        text: Support
        # smartling.sltrans = notranslate
        items:
          -
            # smartling.sltrans = translate
            text: Version Support Policy
            # smartling.sltrans = notranslate
            url: /support-policy/
            src: /gateway/support/index
          -
            # smartling.sltrans = translate
            text: Third Party Dependencies
            # smartling.sltrans = notranslate
            url: /support/third-party
          -
            # smartling.sltrans = translate
            text: Browser Support
            # smartling.sltrans = notranslate
            url: /support/browser
          -
            # smartling.sltrans = translate
            text: Vulnerability Patching Process
            # smartling.sltrans = notranslate
            url: /support/vulnerability-patching-process
          -
            # smartling.sltrans = translate
            text: Software Bill of Materials
            # smartling.sltrans = notranslate
            url: /support/sbom
`;

      const output = yamlPreProcessor(filePath, attributesToTranslate);
      expect(output).toEqual(expectedOutput);
    });
  });
});
