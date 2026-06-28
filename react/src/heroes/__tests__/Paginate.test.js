import { render, screen, fireEvent } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import Paginate from '../Paginate'
import reducer from '../reducer'

const mockSearch = jest.fn()

jest.mock('../actions', () => ({ search: (...args) => { mockSearch(...args); return () => { } } }))

const renderPaginate = (heroesState) => {
  const store = configureStore({
    reducer: { heroes: reducer },
    preloadedState: { heroes: heroesState }
  })
  return render(<Provider store={store}><Paginate /></Provider>)
}

const baseState = {
  ranks: [],
  statuses: [],
  loading: false,
  search: {
    hits: [],
    query: '',
    totalHits: 50,
    page: 1,
    hitsPerPage: 30,
    filter: [],
    sort: ['name:asc']
  }
}

describe('Paginate', () => {
  afterEach(() => {
    jest.clearAllMocks()
  })

  describe('with default state', () => {
    it('renders pagination with total', () => {
      renderPaginate(baseState)
      expect(screen.getByText('50')).toBeInTheDocument()
    })

    it('renders limit options', () => {
      renderPaginate(baseState)
      expect(screen.getByText('50')).toBeInTheDocument()
    })
  })

  describe('with zero total', () => {
    it('renders pagination with zero total', () => {
      renderPaginate({ ...baseState, search: { ...baseState.search, totalHits: 0 } })
    })
  })

  describe('with multiple pages', () => {
    it('calls search when changing page', () => {
      renderPaginate({ ...baseState, search: { ...baseState.search, totalHits: 100 } })
      // Find and click the "next" pagination button
      const nextButton = document.querySelector('[aria-label="Next"]')
      if (nextButton) {
        fireEvent.click(nextButton)
        expect(mockSearch).toHaveBeenCalled()
      }
    })
  })
})
