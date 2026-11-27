import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import { MantineProvider } from '@mantine/core'
import Searcher from '../Searcher'
import reducer from '../reducer'

jest.mock('../actions', () => ({
  create_hero: () => () => Promise.resolve({ id: 1 }),
  update_hero: () => () => Promise.resolve({ id: 1 }),
  get_ranks: () => ({ type: 'RANKS_FETCHED', payload: ['s', 'a', 'b', 'c'] })
}))

const renderSearcher = (state) => {
  const store = configureStore({
    reducer: { heroes: reducer },
    preloadedState: { heroes: state }
  })
  return {
    store,
    ...render(
      <Provider store={store}>
        <MantineProvider>
          <Searcher />
        </MantineProvider>
      </Provider>
    )
  }
}

const baseState = {
  ranks: ['s', 'a', 'b', 'c'],
  statuses: ['enabled', 'disabled', 'working'],
  loading: false,
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

describe('Searcher', () => {
  it('renders search input and hero button', () => {
    renderSearcher(baseState)
    expect(screen.getByPlaceholderText('Search')).toBeInTheDocument()
    expect(screen.getByText('Hero')).toBeInTheDocument()
  })

  it('renders with existing query value', () => {
    renderSearcher({ ...baseState, search: { ...baseState.search, query: 'existing hero' } })
    const input = screen.getByPlaceholderText('Search')
    expect(input.value).toBe('existing hero')
  })

  it('renders search icon button', () => {
    renderSearcher(baseState)
    expect(screen.getByRole('button', { name: 'Search' })).toBeInTheDocument()
  })

  it('renders plus icon on hero button', () => {
    renderSearcher(baseState)
    const heroButton = screen.getByText('Hero').closest('button')
    expect(heroButton).toBeInTheDocument()
  })

  it('keeps the typed term in the input after searching with Enter', () => {
    const { store } = renderSearcher(baseState)
    const input = screen.getByPlaceholderText('Search')
    fireEvent.change(input, { target: { value: 'hero search' } })
    fireEvent.keyDown(input, { key: 'Enter' })

    expect(store.getState().heroes.search.query).toBe('hero search')
    expect(screen.getByPlaceholderText('Search').value).toBe('hero search')
  })

  it('dispatches QUERY_CHANGED on Escape key (clears input)', () => {
    const { store } = renderSearcher(baseState)
    const input = screen.getByPlaceholderText('Search')
    fireEvent.change(input, { target: { value: 'some query' } })
    fireEvent.keyDown(input, { key: 'Escape' })
    expect(store.getState().heroes.search.query).toBe('')
  })

  it('dispatches QUERY_CHANGED when search icon button is clicked', () => {
    const { store } = renderSearcher(baseState)
    const input = screen.getByPlaceholderText('Search')
    fireEvent.change(input, { target: { value: 'search query' } })
    fireEvent.click(screen.getByRole('button', { name: 'Search' }))
    expect(store.getState().heroes.search.query).toBe('search query')
  })

  it('opens HeroForm when Hero button is clicked', async () => {
    renderSearcher(baseState)
    fireEvent.click(screen.getByText('Hero').closest('button'))
    expect(await screen.findByText('Cancel')).toBeInTheDocument()
  })

  it('closes HeroForm when Cancel is clicked', async () => {
    renderSearcher(baseState)
    fireEvent.click(screen.getByText('Hero').closest('button'))
    fireEvent.click(await screen.findByText('Cancel'))
    await waitFor(() => expect(screen.queryByText('Cancel')).not.toBeInTheDocument())
  })

  it('renders with empty ranks gracefully', () => {
    renderSearcher({ ...baseState, ranks: [] })
    expect(screen.getByPlaceholderText('Search')).toBeInTheDocument()
  })

  it('renders with query and updates input value', () => {
    renderSearcher({ ...baseState, search: { ...baseState.search, query: 'test query' } })
    const input = screen.getByPlaceholderText('Search')
    expect(input).toBeInTheDocument()
  })
})
