const INITIAL_STATE = {
  metrics: {},
  historical_threats: [],
  heroes_working: { global: 0, s: 0, a: 0, b: 0, c: 0, count: 0 }
}

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case "METRICS_FETCHED":
      return {
        ...state,
        metrics: { ...state.metrics, ...action.payload }
      }
    case "HISTORICAL_THREATS_FETCHED":
      return {
        ...state,
        historical_threats: action.payload
      }
    case "WIDGET_HEROES_WORKING_FETCHED":
      return {
        ...state,
        heroes_working: action.payload
      }
    default:
      return state
  }
}

export default reducer
