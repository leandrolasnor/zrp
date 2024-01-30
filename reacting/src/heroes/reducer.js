const INITIAL_STATE = {
  ranks: [],
  search: {
    hits: [],
    query: '',
    totalHits: 0
  }
}

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case 'RANKS_FETCHED':
      return {
        ...state,
        ranks: action.payload
      }
    case 'HERO_CREATED':
      return {
        ...state,
        search: {
          ...state.search,
          hits: [action.payload, ...state.search.hits]
        }
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
