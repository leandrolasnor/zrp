const INITIAL_STATE = {
  metrics: {}
};

var _ = require('lodash');

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case "METRICS_FETCHED":
      return {
        ...state,
        metrics: { ...state.metrics, ...action.payload }
      }
    default:
      return state
  }
}

export default reducer
