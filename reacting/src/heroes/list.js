import { useSelector } from 'react-redux'
import { Table, Col } from 'rsuite'

const { Column, HeaderCell, Cell } = Table
const rowKey = 'name'

const List = props => {
  const { list } = useSelector(state => state.heroes)

  return (
    <Col xs={24} className="mt-3">
      <div style={{ position: 'relative' }}>
        <Table
          shouldUpdateScroll={false} // Prevent the scrollbar from scrolling to the top after the table content area height changes.
          height={500}
          data={list}
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
  )
}

export default List
