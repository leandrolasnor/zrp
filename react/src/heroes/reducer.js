const INITIAL_STATE = {
  ranks: [],
  statuses: [],
  loading: false,
  search: {
    hits: [],
    query: '',
    totalHits: 0,
    page: 1,
    hitsPerPage: 30,
    filter: [],
    sort: ['name:asc'],
    focusTick: 0
  }
}

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case 'SET_SORT':
      return {
        ...state,
        search: {
          ...state.search,
          sort: [`${action.payload.sortColumn}:${action.payload.sortType}`]
        }
      }
    case 'SET_FILTER':
      return {
        ...state,
        search: {
          ...state.search,
          filter: action.payload
        }
      }
    case 'CLEAR_FILTER':
      return {
        ...state,
        search: {
          ...state.search,
          filter: []
        }
      }
    case 'RANKS_FETCHED':
      return {
        ...state,
        ranks: action.payload
      }
    case 'STATUSES_FETCHED':
      return {
        ...state,
        statuses: action.payload
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
        loading: false,
        search: { ...state.search, ...action.payload }
      }
    case 'HEROES_LOADING':
      return {
        ...state,
        loading: true
      }
    case 'QUERY_CHANGED':
      return {
        ...state,
        search: {
          ...state.search,
          query: action.payload
        }
      }
    case 'FOCUS_SEARCH_INPUT':
      return {
        ...state,
        search: {
          ...state.search,
          focusTick: (state.search.focusTick || 0) + 1
        }
      }
    default:
      return state
  }
}

export default reducer
