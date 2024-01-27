const INITIAL_STATE = {
  metrics: {},
  historical_threats: []
}

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case "METRICS_FETCHED":
      return {
        ...state,
        metrics: { ...state.metrics, ...action.payload }
      }
    case "LOGOUT":
      return INITIAL_STATE
    case "HISTORICAL_THREATS_FETCHED":
      return {
        ...state,
        historical_threats: action.payload
      }
    default:
      return state
  }
}

export default reducer
