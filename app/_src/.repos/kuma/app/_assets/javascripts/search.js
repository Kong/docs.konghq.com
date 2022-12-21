document.addEventListener('DOMContentLoaded', (event) => {
  if (document.getElementById('algolia-search-input') !== null) {
    const docsVersion = window.location.pathname.split('/')[2];

    docsearch({
      appId: 'RSEEOBCB49',
      indexName: 'kuma',
      apiKey: '4224b11bee5bf294f73032a4988a00ea',
      inputSelector: '#algolia-search-input',
      algoliaOptions: {
        hitsPerPage: 5,
        facetFilters: ['section:docs', `docsversion:${docsVersion}`]
      },
      // Override selected event to allow for local environment navigation
      handleSelected: (input, event, suggestion) => {
        input.setVal('');
        window.location.href = window.location.protocol + '//' + window.location.host + suggestion.url.split('kuma.io')[1];
      }
    });
  }
});
