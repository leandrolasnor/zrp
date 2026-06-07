import reducer from '../reducer'

const INITIAL_STATE = {
  ranks: [],
  statuses: [],
  search: {
    hits: [],
    query: '',
    totalHits: 0,
    page: 1,
    hitsPerPage: 30,
    filter: [],
    sort: ['name:asc']
  }
}

describe('heroes reducer', () => {
  it('returns initial state', () => {
    expect(reducer(undefined, {})).toEqual(INITIAL_STATE)
  })

  describe('SET_SORT', () => {
    it('sets sort column and type', () => {
      const state = reducer(undefined, { type: 'SET_SORT', payload: { sortColumn: 'rank', sortType: 'desc' } })
      expect(state.search.sort).toEqual(['rank:desc'])
    })

    it('preserves other search fields', () => {
      const state = reducer(undefined, { type: 'SET_SORT', payload: { sortColumn: 'name', sortType: 'desc' } })
      expect(state.search.query).toBe('')
      expect(state.search.page).toBe(1)
    })
  })

  describe('SET_FILTER', () => {
    it('sets filter array', () => {
      const state = reducer(undefined, { type: 'SET_FILTER', payload: ["rank = 's'"] })
      expect(state.search.filter).toEqual(["rank = 's'"])
    })
  })

  describe('CLEAR_FILTER', () => {
    it('clears filter to empty array', () => {
      const state = reducer({ search: { filter: ["rank = 's'"] } }, { type: 'CLEAR_FILTER' })
      expect(state.search.filter).toEqual([])
    })
  })

  describe('RANKS_FETCHED', () => {
    it('sets ranks', () => {
      const state = reducer(undefined, { type: 'RANKS_FETCHED', payload: ['s', 'a', 'b'] })
      expect(state.ranks).toEqual(['s', 'a', 'b'])
    })
  })

  describe('STATUSES_FETCHED', () => {
    it('sets statuses', () => {
      const state = reducer(undefined, { type: 'STATUSES_FETCHED', payload: ['active', 'inactive'] })
      expect(state.statuses).toEqual(['active', 'inactive'])
    })
  })

  describe('HEROES_FETCHED', () => {
    it('merges payload into search', () => {
      const payload = { hits: [{ id: 1, name: 'Test' }], totalHits: 1, page: 1, hitsPerPage: 30 }
      const state = reducer(undefined, { type: 'HEROES_FETCHED', payload })
      expect(state.search.hits).toEqual([{ id: 1, name: 'Test' }])
      expect(state.search.totalHits).toBe(1)
    })
  })

  describe('HERO_CREATED', () => {
    it('prepends hero to hits', () => {
      const state = reducer(
        { search: { hits: [{ id: 1 }] } },
        { type: 'HERO_CREATED', payload: { id: 2, name: 'New' } }
      )
      expect(state.search.hits).toEqual([{ id: 2, name: 'New' }, { id: 1 }])
    })
  })

  describe('HERO_UPDATED', () => {
    it('replaces matching hero in hits', () => {
      const state = reducer(
        { search: { hits: [{ id: 1, name: 'Old' }, { id: 2, name: 'Other' }] } },
        { type: 'HERO_UPDATED', payload: { id: 1, name: 'Updated' } }
      )
      expect(state.search.hits).toEqual([{ id: 1, name: 'Updated' }, { id: 2, name: 'Other' }])
    })
  })

  describe('HERO_DESTROYED', () => {
    it('removes matching hero from hits', () => {
      const state = reducer(
        { search: { hits: [{ id: 1 }, { id: 2 }, { id: 3 }] } },
        { type: 'HERO_DESTROYED', payload: { id: 2 } }
      )
      expect(state.search.hits).toEqual([{ id: 1 }, { id: 3 }])
    })
  })

  describe('QUERY_CHANGED', () => {
    it('sets query string', () => {
      const state = reducer(undefined, { type: 'QUERY_CHANGED', payload: 'hero name' })
      expect(state.search.query).toBe('hero name')
    })
  })

  describe('unknown action', () => {
    it('returns current state', () => {
      const state = { custom: true }
      expect(reducer(state, { type: 'UNKNOWN' })).toBe(state)
    })
  })
})
