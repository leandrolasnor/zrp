import { useState, useEffect } from 'react'
import { useDispatch } from 'react-redux'
import { Row, Col, Pagination } from 'rsuite'
import { search } from './actions.js'

const Paginate = props => {
  const dispatch = useDispatch()
  const { heroes: { search: { query, totalHits, page, hitsPerPage } } } = props
  const [pagination, setPagination] = useState({ page: page || 1, per_page: hitsPerPage || 30 })
  const layout = ['total', '-', 'limit', '|', 'pager', 'skip']
  const limitOptions = [30, 50, 100]
  const handleChangePerPage = per_page => dispatch([setPagination(prev => ({ ...prev, per_page: per_page, page: 1 })), search(query, { per_page: per_page, page: 1 })])
  const handleChangePage = page => dispatch([setPagination(prev => ({ ...prev, page: page })), search(query, { ...pagination, page: page })])

  useEffect(() => {
    dispatch(search(query, { page: page || 1, per_page: hitsPerPage || 30 }))
  },[query])

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
          limit={hitsPerPage || pagination.per_page}
          limitOptions={limitOptions}
          maxButtons={5}
          activePage={page || pagination.page}
          onChangePage={handleChangePage}
          onChangeLimit={handleChangePerPage}
        />
      </Col>
    </Row>
  )
}

export default Paginate
