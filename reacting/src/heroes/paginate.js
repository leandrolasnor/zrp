import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Row, Col, Pagination } from 'rsuite'
import { search } from './actions.js'

const Paginate = props => {
  const dispatch = useDispatch()
  const heroes = useSelector(state => state.heroes)
  const { search: { query, totalHits } } = heroes
  const [pagination, setPagination] = useState({ page: 0, per_page: 30 })
  const layout = ['total', '-', 'limit', '|', 'pager', 'skip']
  const limitOptions = [30, 50, 100]
  const { page, per_page } = pagination

  useEffect(() => {
    page > 0 ? dispatch(search(query, pagination)) : setPagination(prev => ({ ...prev, page: 1 }))
  }, [page])

  useEffect(() => {
    dispatch([setPagination(prev => ({ ...prev, page: 1 })), search(query, pagination)])
  }, [query])

  const handleChangePerPage = per_page => {
    dispatch([setPagination(prev => ({ ...prev, per_page: per_page, page: 1 })), search(query, pagination)])
  }

  const handleChangePage = page => {
    dispatch([setPagination(prev => ({ ...prev, page: page })), search(query, pagination)])
  }

  return (
    <Row className='mt-3'>
      <Col xs={24}>
        <Pagination
          layout={layout}
          size="xs"
          prev={true}
          next={true}
          first={true}
          last={true}
          ellipsis={true}
          boundaryLinks={true}
          total={totalHits}
          limit={per_page}
          limitOptions={limitOptions}
          maxButtons={5}
          activePage={page}
          onChangePage={handleChangePage}
          onChangeLimit={handleChangePerPage}
        />
      </Col>
    </Row>
  )
}

export default Paginate
