import { render, screen, fireEvent } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import { MantineProvider } from '@mantine/core'
import Paginate from '../Paginate'
import reducer from '../reducer'

const mockSearch = jest.fn()

jest.mock('../actions', () => ({ search: (...args) => { mockSearch(...args); return () => { } } }))

const renderPaginate = (heroesState) => {
  const store = configureStore({
    reducer: { heroes: reducer },
    preloadedState: { heroes: heroesState }
  })
  return render(
    <Provider store={store}>
      <MantineProvider>
        <Paginate />
      </MantineProvider>
    </Provider>
  )
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
      expect(screen.getByRole('button', { name: '1' })).toHaveAttribute('aria-current', 'page')
      expect(screen.getByRole('button', { name: '2' })).toBeInTheDocument()
    })

    it('derives the page count from hitsPerPage', () => {
      renderPaginate(baseState)
      expect(screen.getByRole('button', { name: '2' })).toBeInTheDocument()
      expect(screen.queryByRole('button', { name: '3' })).not.toBeInTheDocument()
    })
  })

  describe('with zero total', () => {
    it('renders pagination with zero total', () => {
      renderPaginate({ ...baseState, search: { ...baseState.search, totalHits: 0 } })
      expect(screen.getByRole('button', { name: '1' })).toBeInTheDocument()
      expect(screen.queryByRole('button', { name: '2' })).not.toBeInTheDocument()
    })
  })

  describe('with multiple pages', () => {
    it('calls search when changing page', () => {
      renderPaginate({ ...baseState, search: { ...baseState.search, totalHits: 100 } })
      fireEvent.click(screen.getByRole('button', { name: '2' }))
      expect(mockSearch).toHaveBeenCalledWith('', { per_page: 30, page: 2 }, [], ['name:asc'])
    })
  })
})
