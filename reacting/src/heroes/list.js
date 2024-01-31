import { Table, Row, Col } from 'rsuite'

const { Column, HeaderCell, Cell } = Table
const rowKey = 'id'

const List = props => {
  const { heroes: { search: { hits } } } = props

  return (
    <Row>
      <Col xs={24} className="mt-3">
        <div style={{ position: 'relative' }}>
          <Table
            shouldUpdateScroll={false}
            autoHeight={true}
            data={hits}
            rowKey={rowKey}
            bordered={true}
            cellBordered={true}
            headerHeight={30}
          >
            <Column flexGrow={1}>
              <HeaderCell>Name</HeaderCell>
              <Cell dataKey="name" />
            </Column>
            <Column flexGrow={1}>
              <HeaderCell>Rank</HeaderCell>
              <Cell dataKey="rank" />
            </Column>
            <Column flexGrow={1}>
              <HeaderCell>LAT</HeaderCell>
              <Cell dataKey="lat" />
            </Column>
            <Column flexGrow={1}>
              <HeaderCell>LNG</HeaderCell>
              <Cell dataKey="lng" />
            </Column>
          </Table>
        </div>
      </Col>
    </Row>
  )
}

export default List
