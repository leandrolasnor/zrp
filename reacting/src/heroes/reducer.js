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
    case 'HERO_UPDATED':
      return {
        ...state,
        search: {
          ...state.search,
          hits: state.search.hits.map(hit => hit.id == action.payload.id ? action.payload : hit)
        }
      }
    case 'HERO_DESTROYED':
      return {
        ...state,
        search: {
          ...state.search,
          hits: state.search.hits.filter(hit => hit.id != action.payload.id)
        }
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
