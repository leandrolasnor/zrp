import axios from 'axios'
import qs from 'qs'
import { search, create_hero, update_hero, destroy_hero, get_ranks, get_statuses } from '../actions'

jest.mock('axios')

const mockDispatch = jest.fn()

describe('heroes actions', () => {
  afterEach(() => {
    jest.clearAllMocks()
  })

  describe('search', () => {
    it('dispatches HEROES_FETCHED on success', async () => {
      const resp = { data: { hits: [{ id: 1 }], totalHits: 1 } }
      axios.get.mockResolvedValue(resp)

      await search('test', { page: 1, per_page: 30 }, [], ['name:asc'])(mockDispatch)

      expect(axios.get).toHaveBeenCalledWith('/v1/heroes/search', expect.objectContaining({
        params: expect.objectContaining({ query: 'test', page: 1, per_page: 30 })
      }))
      expect(axios.get).toHaveBeenCalledWith('/v1/heroes/search', expect.objectContaining({
        paramsSerializer: expect.any(Function)
      }))
      // Invoke paramsSerializer to cover line 13
      const config = axios.get.mock.calls[0][1]
      const result = config.paramsSerializer({ query: 'test', page: 1, per_page: 30 })
      expect(typeof result).toBe('string')
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'HEROES_FETCHED', payload: resp.data })
    })

    it('dispatches HEROES_LOADING on API error', async () => {
      axios.get.mockRejectedValue(new Error('Network Error'))

      await search('test', { page: 1, per_page: 30 }, [], [])(mockDispatch)

      expect(mockDispatch).toHaveBeenCalledWith({ type: 'HEROES_LOADING' })
      expect(mockDispatch).not.toHaveBeenCalledWith({ type: 'HEROES_FETCHED', payload: expect.anything() })
    })

    it('calls search with sort parameters', async () => {
      axios.get.mockResolvedValue({ data: { hits: [] } })

      await search('test', { page: 1, per_page: 30 }, [], ['rank:desc'])(mockDispatch)

      expect(axios.get).toHaveBeenCalledWith('/v1/heroes/search', expect.objectContaining({
        params: expect.objectContaining({ sort: ['rank:desc'] })
      }))
    })

    it('calls search with filter parameters', async () => {
      axios.get.mockResolvedValue({ data: { hits: [] } })

      await search('test', { page: 1, per_page: 30 }, ["rank = 's'"], ['name:asc'])(mockDispatch)

      expect(axios.get).toHaveBeenCalledWith('/v1/heroes/search', expect.objectContaining({
        params: expect.objectContaining({ filter: ["rank = 's'"] })
      }))
    })

    it('calls search with empty query', async () => {
      axios.get.mockResolvedValue({ data: { hits: [] } })

      await search('', { page: 1, per_page: 30 }, [], [])(mockDispatch)

      expect(axios.get).toHaveBeenCalled()
    })
  })

  describe('create_hero', () => {
    it('dispatches HERO_CREATED on success', async () => {
      const hero = { id: 1, name: 'New Hero' }
      axios.post.mockResolvedValue({ data: hero })

      await create_hero({ name: 'New Hero' })(mockDispatch)

      expect(axios.post).toHaveBeenCalledWith('/v1/heroes', { name: 'New Hero' })
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'HERO_CREATED', payload: hero })
    })

    it('handles API error gracefully', async () => {
      axios.post.mockRejectedValue(new Error('Network Error'))

      try {
        await create_hero({ name: 'New Hero' })(mockDispatch)
      } catch (e) {
        // Expected error — action re-throws after handling
      }

      expect(mockDispatch).not.toHaveBeenCalledWith({ type: 'HERO_CREATED', payload: expect.anything() })
    })
  })

  describe('update_hero', () => {
    it('dispatches HERO_UPDATED on success', async () => {
      const hero = { id: 1, name: 'Updated' }
      axios.patch.mockResolvedValue({ data: hero })

      await update_hero(hero)(mockDispatch)

      expect(axios.patch).toHaveBeenCalledWith('/v1/heroes/1', hero)
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'HERO_UPDATED', payload: hero })
    })

    it('handles API error gracefully', async () => {
      axios.patch.mockRejectedValue(new Error('Network Error'))

      try {
        await update_hero({ id: 1, name: 'Updated' })(mockDispatch)
      } catch (e) {
        // Expected error — action re-throws after handling
      }

      expect(mockDispatch).not.toHaveBeenCalledWith({ type: 'HERO_UPDATED', payload: expect.anything() })
    })
  })

  describe('destroy_hero', () => {
    it('dispatches HERO_DESTROYED on success', async () => {
      const hero = { id: 1, name: 'To Delete' }
      axios.delete.mockResolvedValue({ data: hero })

      await destroy_hero(hero)(mockDispatch)

      expect(axios.delete).toHaveBeenCalledWith('/v1/heroes/1')
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'HERO_DESTROYED', payload: hero })
    })

    it('handles API error gracefully', async () => {
      axios.delete.mockRejectedValue(new Error('Network Error'))

      await destroy_hero({ id: 1 })(mockDispatch)

      expect(mockDispatch).not.toHaveBeenCalledWith({ type: 'HERO_DESTROYED', payload: expect.anything() })
    })
  })

  describe('get_ranks', () => {
    it('dispatches RANKS_FETCHED on success', async () => {
      const ranks = ['s', 'a', 'b']
      axios.get.mockResolvedValue({ data: ranks })

      await get_ranks()(mockDispatch)

      expect(axios.get).toHaveBeenCalledWith('/v1/heroes/ranks')
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'RANKS_FETCHED', payload: ranks })
    })

    it('handles API error gracefully', async () => {
      axios.get.mockRejectedValue(new Error('Network Error'))

      await get_ranks()(mockDispatch)

      expect(mockDispatch).not.toHaveBeenCalledWith({ type: 'RANKS_FETCHED', payload: expect.anything() })
    })
  })

  describe('get_statuses', () => {
    it('dispatches STATUSES_FETCHED on success', async () => {
      const statuses = ['active', 'inactive']
      axios.get.mockResolvedValue({ data: statuses })

      await get_statuses()(mockDispatch)

      expect(axios.get).toHaveBeenCalledWith('/v1/heroes/statuses')
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'STATUSES_FETCHED', payload: statuses })
    })

    it('handles API error gracefully', async () => {
      axios.get.mockRejectedValue(new Error('Network Error'))

      await get_statuses()(mockDispatch)

      expect(mockDispatch).not.toHaveBeenCalledWith({ type: 'STATUSES_FETCHED', payload: expect.anything() })
    })
  })
})
