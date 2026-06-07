import { render, screen } from '@testing-library/react'
import Paginate from '../paginate'

jest.mock('react-redux', () => ({
  useDispatch: () => jest.fn(),
  useSelector: () => ({
    ranks: [],
    statuses: [],
    search: { hits: [], query: '', totalHits: 50, page: 1, hitsPerPage: 30, filter: [], sort: ['name:asc'] }
  })
}))

jest.mock('../actions', () => ({ search: () => () => {} }))

describe('Paginate', () => {
  it('renders pagination', () => {
    render(<Paginate />)
    expect(screen.getByText('50')).toBeInTheDocument()
  })
})
