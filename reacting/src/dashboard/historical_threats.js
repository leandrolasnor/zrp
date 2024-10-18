import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Icon } from '@rsuite/icons'
import { Table, IconButton, Row, Col, Badge, Tag, TagGroup } from 'rsuite'
import CollaspedOutlineIcon from '@rsuite/icons/CollaspedOutline';
import ExpandOutlineIcon from '@rsuite/icons/ExpandOutline';
import { historical_threats as historical } from './actions.js'
import { FaArrowRotateRight } from 'react-icons/fa6'

const { Column, HeaderCell, Cell } = Table;
const rowKey = 'id';
const ExpandCell = ({ rowData, dataKey, expandedRowKeys, onChange, ...props }) => (
  <Cell {...props} style={{ padding: 5 }}>
    <IconButton
      appearance="subtle"
      onClick={() => {
        onChange(rowData);
      }}
      icon={
        expandedRowKeys.some(key => key === rowData[rowKey]) ? (
          <CollaspedOutlineIcon />
        ) : (
          <ExpandOutlineIcon />
        )
      }
    />
  </Cell>
)

const Duration = props => {
  const { duration } = props

  return (
    `
      ${~~Number(duration.hours).toFixed(0) || '0'}h
      ${~~Number(duration.minutes).toFixed(2) || '0'}min
      ${~~Number(duration.seconds).toFixed(2) || '0'}sec
    `
  )
}

const NameCell = ({ rowData, dataKey, ...props }) => {
  const colors = {
    god: 'blue',
    dragon: 'green',
    tiger: 'violet',
    wolf: 'red'
  }

  return (
    <Cell {...props}>
      <Row>
        <Col>
          {rowData[dataKey]}
        </Col>
        <Col>
          <Badge color={colors[rowData.rank]} content={rowData.rank} />
        </Col>
      </Row>
    </Cell>
  );
}

const CreatedAtCell = ({ rowData, dataKey, ...props }) => {
  const { battle } = rowData
  return <Cell {...props}>{battle.created_at}</Cell>
}

const FinishedAtCell = ({ rowData, dataKey, ...props }) => {
  const { battle } = rowData
  return <Cell {...props}>{battle.finished_at}</Cell>
}

const Heroes = props => {
  const { heroes } = props
  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }
  if (heroes.length === 1) return <Badge color={colors[heroes[0].rank]} content={heroes[0].rank}>{heroes[0].name}</Badge>
  return (
    <>
      <Tag>
        <Badge color={colors[heroes[0].rank]} content={heroes[0].rank}>{heroes[0].name}</Badge>
      </Tag>
      <Tag>
        <Badge color={colors[heroes[1].rank]} content={heroes[1].rank}>{heroes[1].name}</Badge>
      </Tag>
    </>
  )

}

const renderRowExpanded = rowData => {
  const { battle } = rowData
  const { heroes } = battle

  return (
    <Row className="mt-1">
      <TagGroup>
        <Tag>{battle.score}</Tag>
        <Tag><Heroes heroes={heroes} /></Tag>
        <Tag><Duration duration={battle.duration} /></Tag>
      </TagGroup>
    </Row>
  );
};

const HistoricalThreats = () => {
  const { historical_threats, threats_disabled: { count } } = useSelector(state => state.metrics)
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(historical({ page: 1, per_page: 50 }))
  }, [count, dispatch])

  const [expandedRowKeys, setExpandedRowKeys] = useState([]);

  const handleExpanded = (rowData, dataKey) => {
    let open = false;
    const nextExpandedRowKeys = [];

    expandedRowKeys.forEach(key => {
      if (key === rowData[rowKey]) {
        open = true;
      } else {
        nextExpandedRowKeys.push(key);
      }
    });

    if (!open) {
      nextExpandedRowKeys.push(rowData[rowKey]);
    }

    setExpandedRowKeys(nextExpandedRowKeys);
  };

  return (
    <div style={{ position: 'relative' }}>
      <Table
        shouldUpdateScroll={false} // Prevent the scrollbar from scrolling to the top after the table content area height changes.
        autoHeight={true}
        data={historical_threats}
        rowKey={rowKey}
        expandedRowKeys={expandedRowKeys}
        renderRowExpanded={renderRowExpanded}
        bordered={true}
        cellBordered={true}
        headerHeight={30}
      >
        <Column align="center" flexGrow={0}>
          <HeaderCell style={{ padding: 0 }}>
            <Row className='mt-1'>
              <IconButton onClick={() => dispatch(historical({ page: 1, per_page: 50 }))} appearance='subtle' circle size="xs" icon={<Icon as={FaArrowRotateRight} />} />
            </Row>
          </HeaderCell>
          <ExpandCell dataKey="battle" expandedRowKeys={expandedRowKeys} onChange={handleExpanded} />
        </Column>
        <Column flexGrow={1}>
          <HeaderCell>NAME</HeaderCell>
          <NameCell dataKey="name" />
        </Column>
        <Column flexGrow={1}>
          <HeaderCell>LOCATION</HeaderCell>
          <Cell>
            {row => {
              return (
                <TagGroup>
                  <Tag>{row.lat}</Tag>
                  <Tag>{row.lng}</Tag>
                </TagGroup>
              )
            }
            }
          </Cell>
        </Column>
        <Column flexGrow={1}>
          <HeaderCell>INITIAL DATE</HeaderCell>
          <CreatedAtCell dataKey="created_at" />
        </Column>
        <Column flexGrow={1}>
          <HeaderCell>FINISH DATE</HeaderCell>
          <FinishedAtCell dataKey="finished_at" />
        </Column>
      </Table>
    </div>
  );
};

export default HistoricalThreats
