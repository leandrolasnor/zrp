import { useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Row, Col, Pagination } from 'rsuite'
import { search } from './actions.js'

const Paginate = () => {
  const dispatch = useDispatch()
  const { search: { query, totalHits, page, hitsPerPage } }  = useSelector(state => state.heroes)
  const layout = ['total', '-', 'limit', '|', 'pager', 'skip']
  const limitOptions = [30, 50, 100]
  const handleChangePerPage = per_page => dispatch(search(query, { per_page: per_page, page: 1 }))
  const handleChangePage = page => dispatch(search(query, { per_page: hitsPerPage || limitOptions[0], page: page }))

  useEffect(() => {
    dispatch(search(query, { page: 1, per_page: hitsPerPage || limitOptions[0] }))
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
          limit={hitsPerPage || limitOptions[0]}
          limitOptions={limitOptions}
          maxButtons={5}
          activePage={page || 1}
          onChangePage={handleChangePage}
          onChangeLimit={handleChangePerPage}
        />
      </Col>
    </Row>
  )
}

export default Paginate
