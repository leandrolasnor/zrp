const INITIAL_STATE = {
  threats: [],
  hovered: null,
  selected: null,
  rotation: 0,
  tilt: 0
}

const reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case 'EARTH_THREATS_FETCHED':
      return { ...state, threats: action.payload ?? [] }
    case 'EARTH_THREAT_HOVERED':
      return { ...state, hovered: action.payload }
    case 'EARTH_THREAT_SELECTED':
      return { ...state, selected: action.payload, hovered: null }
    case 'EARTH_THREAT_CLOSED':
      return { ...state, selected: null }
    case 'EARTH_ROTATION_CHANGED':
      return { ...state, ...(action.payload ?? {}) }
    default:
      return state
  }
}

export default reducer
