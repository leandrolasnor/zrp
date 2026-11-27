import { useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Pagination } from '@mantine/core'
import { search } from './actions.js'

const Paginate = () => {
  const dispatch = useDispatch()
  const { search: { query, totalHits, page, hitsPerPage, filter, sort } } = useSelector(state => state.heroes)
  const limitOptions = [30, 50, 100]
  const limit = hitsPerPage || limitOptions[0]
  const handleChangePerPage = per_page => dispatch(search(query, { per_page: per_page, page: 1 }, filter, sort))
  const handleChangePage = (newPage) => dispatch(search(query, { per_page: limit, page: newPage }, filter, sort))

  useEffect(() => {
    dispatch(search(query, { page: 1, per_page: limit }, filter, sort || []))
  }, [query, filter, sort])

  const totalPages = Math.ceil((totalHits || 0) / limit) || 1

  return (
    <div style={{ marginTop: 12 }}>
      <Pagination total={totalPages} value={page || 1} onChange={handleChangePage} size="xs" />
    </div>
  )
}

export default Paginate
