import { Table, IconButton, Row, Col } from 'rsuite'
import { Icon } from '@rsuite/icons'
import { FaArrowRotateRight } from 'react-icons/fa6'

const { Column, HeaderCell, Cell } = Table
const rowKey = 'name'

const List = props => {
  return (
    <Col xs={24} className="mt-3">
      <div style={{ position: 'relative' }}>
        <Table
          shouldUpdateScroll={false} // Prevent the scrollbar from scrolling to the top after the table content area height changes.
          height={500}
          data={[]}
          rowKey={rowKey}
          bordered={true}
          cellBordered={true}
          headerHeight={30}
        >
          <Column flexGrow={1}>
            <HeaderCell>Name</HeaderCell>
            <Cell dataKey="name" />
          </Column>
        </Table>
      </div>
    </Col>
  )
}

export default List
