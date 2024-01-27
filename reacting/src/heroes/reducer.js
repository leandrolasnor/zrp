const INITIAL_STATE = {
  list: []
}

var reducer = (state = INITIAL_STATE, action) => {
  switch(action.type) {
    case "HEROES_FETCHED":
      return {
        ...state,
        list: action.payload
      }
    case "LOGOUT":
      return INITIAL_STATE
    default:
      return state
  }
}

export default reducer
