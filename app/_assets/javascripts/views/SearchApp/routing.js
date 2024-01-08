import { history } from 'instantsearch.js/es/lib/routers';

const indexName = 'konghq';

export const routing = {
  router: history(),
  stateMapping: {
    stateToRoute(uiState) {
      const indexUiState = uiState[indexName] || {};

      return {
        query: indexUiState.query,
        page: indexUiState.page,
        product: indexUiState.refinementList && indexUiState.refinementList.product,
        version: indexUiState.refinementList && indexUiState.refinementList.version
      };
    },

    routeToState(routeState) {
      return {
        [indexName]: {
          query: routeState.query,
          page: routeState.page,
          refinementList: {
            product: routeState.product,
            version: routeState.version
          },
        },
      };
    },
  },
};

