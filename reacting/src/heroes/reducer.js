const INITIAL_STATE = {
  search: {
    hits: [],
    query: '',
    totalHits: 0
  }
}

var reducer = (state = INITIAL_STATE, action) => {
  switch(action.type) {
    case 'HERO_CREATED':
      return {
        ...state,
        hits: [action.payload, ...state.hits ]
      }
    case 'HEROES_FETCHED':
      return {
        ...state,
        search: action.payload
      }
    case 'QUERY_CHANGED':
      return {
        ...state,
        search: {
          ...state.search,
          query: action.payload
        }
      }
    default:
      return state
  }
}

export default reducer
