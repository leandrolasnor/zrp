import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import Searcher from '../searcher'
import reducer from '../reducer'

const renderSearcher = (state) => {
  const store = configureStore({ reducer: { heroes: reducer }, preloadedState: { heroes: state } })
  return render(<Provider store={store}><Searcher /></Provider>)
}

describe('Searcher', () => {
  const baseState = {
    ranks: [],
    statuses: [],
    search: { hits: [], query: '', totalHits: 0, page: 1, hitsPerPage: 30, filter: [], sort: ['name:asc'] }
  }

  it('renders search input and hero button', () => {
    renderSearcher(baseState)
    expect(screen.getByPlaceholderText('Search')).toBeInTheDocument()
    expect(screen.getByText('Hero')).toBeInTheDocument()
  })

  it('renders with existing query', () => {
    renderSearcher({ ...baseState, search: { ...baseState.search, query: 'hero' } })
    const input = screen.getByPlaceholderText('Search')
    expect(input).toBeInTheDocument()
  })
})
