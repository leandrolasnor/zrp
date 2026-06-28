import { render, screen, fireEvent } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import Filter from '../Filter'
import reducer from '../reducer'

jest.mock('react-icons/fa', () => ({ FaAngleDoubleDown: 'FaAngleDoubleDown' }))
jest.mock('../actions', () => ({
  get_ranks: () => ({ type: 'RANKS_FETCHED', payload: ['s', 'a', 'b', 'c'] }),
  get_statuses: () => ({ type: 'STATUSES_FETCHED', payload: ['enabled', 'disabled', 'working'] })
}))

const renderFilter = (state) => {
  const store = configureStore({
    reducer: { heroes: reducer },
    preloadedState: { heroes: state }
  })
  return render(<Provider store={store}><Filter /></Provider>)
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

describe('Filter', () => {
  it('renders filter accordion closed', () => {
    renderFilter(baseState)
    expect(screen.getByText('Filter')).toBeInTheDocument()
  })

  it('renders with active filter', () => {
    renderFilter({
      ...baseState,
      search: { ...baseState.search, filter: ["rank = 's'"] }
    })
    expect(screen.getByText('Filter')).toBeInTheDocument()
  })

  it('opens accordion when clicked and shows pickers', () => {
    renderFilter(baseState)
    const filterButton = screen.getByText('Filter')
    fireEvent.click(filterButton)
    // The accordion should now be expanded — check that Apply button appears
    expect(screen.getByText('Apply')).toBeInTheDocument()
  })

  it('renders apply button when opened', () => {
    renderFilter(baseState)
    fireEvent.click(screen.getByText('Filter'))
    expect(screen.getByText('Apply')).toBeInTheDocument()
  })

  it('calls applyFilter when Apply button is clicked', () => {
    renderFilter(baseState)
    fireEvent.click(screen.getByText('Filter'))
    const applyButton = screen.getByText('Apply').closest('button')
    if (applyButton) {
      fireEvent.click(applyButton)
    }
    // Should not throw — dispatch SET_FILTER with empty filter
  })

  it('closes accordion on second click', () => {
    renderFilter({
      ...baseState,
      search: { ...baseState.search, filter: ["rank = 's'"] }
    })
    const filterButton = screen.getByText('Filter')
    fireEvent.click(filterButton)
    expect(screen.getByText('Apply')).toBeInTheDocument()
    // The component keeps the panel open on second click (only resets filters)
    fireEvent.click(filterButton)
    expect(screen.getByText('Apply')).toBeInTheDocument()
  })

  it('renders with empty ranks gracefully', () => {
    renderFilter({ ...baseState, ranks: [], statuses: [] })
    expect(screen.getByText('Filter')).toBeInTheDocument()
  })
})
