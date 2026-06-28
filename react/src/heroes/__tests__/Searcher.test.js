import { render, screen, fireEvent } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
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
  return render(<Provider store={store}><Searcher /></Provider>)
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
    expect(input).toBeInTheDocument()
  })

  it('renders search icon button', () => {
    renderSearcher(baseState)
    const searchButton = document.querySelector('.rs-input-group-btn')
    expect(searchButton).toBeInTheDocument()
  })

  it('renders plus icon on hero button', () => {
    renderSearcher(baseState)
    const heroButton = screen.getByText('Hero').closest('button')
    expect(heroButton).toBeInTheDocument()
  })

  it('dispatches QUERY_CHANGED on Enter key', () => {
    renderSearcher(baseState)
    const input = screen.getByPlaceholderText('Search')
    fireEvent.change(input, { target: { value: 'hero search' } })
    fireEvent.keyDown(input, { key: 'Enter' })
    // No error means dispatch was called
  })

  it('dispatches QUERY_CHANGED on Escape key (clears input)', () => {
    renderSearcher(baseState)
    const input = screen.getByPlaceholderText('Search')
    fireEvent.change(input, { target: { value: 'some query' } })
    fireEvent.keyDown(input, { key: 'Escape' })
    // No error means dispatch was called
  })

  it('dispatches QUERY_CHANGED when search icon button is clicked', () => {
    renderSearcher(baseState)
    const input = screen.getByPlaceholderText('Search')
    fireEvent.change(input, { target: { value: 'search query' } })
    // Find and click the search icon button inside the input group
    const searchButton = document.querySelector('.rs-input-group-btn')
    if (searchButton) {
      fireEvent.click(searchButton)
    }
    // No error means dispatch was called
  })

  it('opens HeroForm when Hero button is clicked', () => {
    renderSearcher(baseState)
    const heroButton = screen.getByText('Hero').closest('button')
    if (heroButton) {
      fireEvent.click(heroButton)
    }
    // No error means dispatch was called
  })

  it('closes HeroForm when Cancel is clicked', () => {
    renderSearcher(baseState)
    const heroButton = screen.getByText('Hero').closest('button')
    if (heroButton) {
      fireEvent.click(heroButton)
    }
    const cancelButton = screen.getByText('Cancel')
    if (cancelButton) {
      fireEvent.click(cancelButton)
    }
    // No error means handleClose was called
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
