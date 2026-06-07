import axios from 'axios'
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
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'HEROES_FETCHED', payload: resp.data })
    })

    it('does not dispatch on API error', async () => {
      axios.get.mockRejectedValue(new Error('Network Error'))

      await search('test', { page: 1, per_page: 30 }, [], [])(mockDispatch)

      expect(mockDispatch).not.toHaveBeenCalled()
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
  })

  describe('update_hero', () => {
    it('dispatches HERO_UPDATED on success', async () => {
      const hero = { id: 1, name: 'Updated' }
      axios.patch.mockResolvedValue({ data: hero })

      await update_hero(hero)(mockDispatch)

      expect(axios.patch).toHaveBeenCalledWith('/v1/heroes/1', hero)
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'HERO_UPDATED', payload: hero })
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
  })

  describe('get_ranks', () => {
    it('dispatches RANKS_FETCHED on success', async () => {
      const ranks = ['s', 'a', 'b']
      axios.get.mockResolvedValue({ data: ranks })

      await get_ranks()(mockDispatch)

      expect(axios.get).toHaveBeenCalledWith('/v1/heroes/ranks')
      expect(mockDispatch).toHaveBeenCalledWith({ type: 'RANKS_FETCHED', payload: ranks })
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
  })
})
