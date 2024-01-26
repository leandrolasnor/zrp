import { Col, Pagination } from 'rsuite'

const Paginate = props => {
  const layout = ['total', '-', 'limit', '|', 'pager', 'skip']
  const limitOptions = [30, 50, 100]

  return (
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
        total={200}
        limit={50}
        limitOptions={limitOptions}
        maxButtons={5}
        activePage={1}
        // onChangePage={setActivePage}
        onChangeLimit={50}
      />
    </Col>
  )
}

export default Paginate
