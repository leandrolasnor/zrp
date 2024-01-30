import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Icon } from '@rsuite/icons'
import { Table, IconButton, Row, Col, Badge, Tag, TagGroup } from 'rsuite'
import CollaspedOutlineIcon from '@rsuite/icons/CollaspedOutline';
import ExpandOutlineIcon from '@rsuite/icons/ExpandOutline';
import { historical_threats as historical } from './actions.js'
import { FaArrowRotateRight } from 'react-icons/fa6'

const { Column, HeaderCell, Cell } = Table;
const rowKey = 'name';
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
    <Tag>
      {`
      ${~~Number(duration.hours).toFixed(0) || '0'}h
      ${~~Number(duration.minutes).toFixed(2) || '0'}min
      ${~~Number(duration.seconds).toFixed(2) || '0'}sec
      `}
    </Tag>
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

const BadgeHero = props => {
  const { hero } = props
  if (!hero) return null

  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }
  return (
    <Badge color={colors[hero.rank]} content={hero.rank}>
      <Tag>{hero.name}</Tag>
    </Badge>
  )
}

const renderRowExpanded = rowData => {
  const { battle } = rowData
  const { heroes } = battle

  return (
    <Row className="mt-3">
      <TagGroup>
        <Tag>{battle.score}</Tag>
        <BadgeHero hero={heroes[0]} />
        <BadgeHero hero={heroes[1]} />
        <Duration duration={battle.duration} />
      </TagGroup>
    </Row>
  );
};

const HistoricalThreats = () => {
  const { historical_threats } = useSelector(state => state.metrics)
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(historical({ page: 1, per_page: 50 }))
  }, [])

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
        height={500}
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
          <HeaderCell>Name</HeaderCell>
          <NameCell dataKey="name" />
        </Column>
        <Column flexGrow={1}>
          <HeaderCell>Latitude</HeaderCell>
          <Cell dataKey="lat" />
        </Column>
        <Column flexGrow={1}>
          <HeaderCell>Longitude</HeaderCell>
          <Cell dataKey="lng" />
        </Column>
        <Column flexGrow={1}>
          <HeaderCell>Initial date</HeaderCell>
          <CreatedAtCell dataKey="created_at" />
        </Column>
        <Column flexGrow={1}>
          <HeaderCell>Finish date</HeaderCell>
          <FinishedAtCell dataKey="finished_at" />
        </Column>
      </Table>
    </div>
  );
};

export default HistoricalThreats
