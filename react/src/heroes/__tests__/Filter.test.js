import { render, screen } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import Filter from '../filter'
import reducer from '../reducer'

jest.mock('react-icons/fa', () => ({ FaAngleDoubleDown: 'FaAngleDoubleDown' }))
jest.mock('../actions', () => ({
  get_ranks: jest.fn(() => () => {}),
  get_statuses: jest.fn(() => () => {})
}))

const renderFilter = (state) => {
  const store = configureStore({
    reducer: { heroes: reducer },
    preloadedState: { heroes: state }
  })
  return render(<Provider store={store}><Filter /></Provider>)
}

const baseState = {
  ranks: ['s', 'a'],
  statuses: ['active'],
  search: { hits: [], query: '', totalHits: 0, page: 1, hitsPerPage: 30, filter: [], sort: ['name:asc'] }
}

describe('Filter', () => {
  it('renders filter accordion', () => {
    renderFilter(baseState)
    expect(screen.getByText('Filter')).toBeInTheDocument()
  })

  it('renders with active filter', () => {
    renderFilter({ ...baseState, search: { ...baseState.search, filter: ["rank = 's'"] } })
    expect(screen.getByText('Filter')).toBeInTheDocument()
  })
})
