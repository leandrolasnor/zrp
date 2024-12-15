const INITIAL_STATE = {
  super_hero: null,
  historical_threats: [],
  average_score: 0,
  average_time_to_match: { hours: 0, minutes: 0, seconds: 0 },
  heroes_working: { global: 0, s: 0, a: 0, b: 0, c: 0, count: 0 },
  threats_disabled: { global: 0, god: 0, dragon: 0, tiger: 0, wolf: 0, count: 0 },
  heroes_distribution: null,
  threats_distribution: null,
  battles_lineup: [
    ['One Hero', 0],
    ['Two Heroes', 0]
  ]
}

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case "METRICS_FETCHED":
      return {
        ...state,
        ...action.payload
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
    case "WIDGET_THREATS_DISABLED_FETCHED":
      return {
        ...state,
        threats_disabled: action.payload
      }
    case "WIDGET_BATTLES_LINEUP_FETCHED":
      return {
        ...state,
        battles_lineup: action.payload
      }
    case "WIDGET_AVERAGE_SCORE_FETCHED":
      return {
        ...state,
        average_score: action.payload
      }
    case "WIDGET_AVERAGE_TIME_TO_MATCH_FETCHED":
      return {
        ...state,
        average_time_to_match: action.payload
      }
    case "WIDGET_SUPER_HERO_FETCHED":
      return {
        ...state,
        super_hero: action.payload
      }
    case "WIDGET_THREATS_DISTRIBUTION_FETCHED":
      return {
        ...state,
        threats_distribution: action.payload
      }
    case "WIDGET_HEROES_DISTRIBUTION_FETCHED":
      return {
        ...state,
        heroes_distribution: action.payload
      }
    default:
      return state
  }
}

export default reducer
