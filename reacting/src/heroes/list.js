import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Table, Row, Col, Button, Badge, TagGroup, Tag, IconButton } from 'rsuite'
import { Icon } from '@rsuite/icons'
import { FaTrashCan, FaFilePen, FaTrophy, FaClipboardCheck } from 'react-icons/fa6'
import HeroForm from './hero_form'
import { destroy_hero } from './actions'

const _ = require('lodash')

const { Column, HeaderCell, Cell } = Table
const rowKey = 'id'

const List = () => {
  const dispatch = useDispatch()
  const { search: { hits, query, filter } } = useSelector(state => state.heroes)
  const { super_hero } = useSelector(state => state.metrics)
  const [openUpdateHeroForm, setOpenUpdateHeroForm] = useState(false)
  const [dataHeroForm, setDataHeroForm] = useState({})
  const [sortColumn, setSortColumn] = useState();
  const [sortType, setSortType] = useState();

  useEffect(() => { setOpenUpdateHeroForm(Object.keys(dataHeroForm).length > 0) }, [dataHeroForm])
  useEffect(() => { setSortColumn(''); setSortType(''); }, [query, filter])

  const handleSortColumn = (sortColumn, sortType) => {
    setSortColumn(sortColumn);
    setSortType(sortType);
    dispatch({ type: 'SET_SORT', payload: { sortColumn: sortColumn, sortType: sortType } })
  };

  const statusColors = {
    enabled: 'green',
    working: 'red',
    disable: 'violet'
  }
  const rankColors = {
    s: 'cyan',
    a: 'green',
    b: 'violet',
    c: 'red'
  }

  const NameCell = ({ rowData, dataKey, ...props }) => {
    return (
      <Cell {...props}>
        <Row>
          <Col>
            {_.get(super_hero, 'name', '') === rowData.name ? <Badge color='orange' content={<Icon as={FaTrophy} />}>{rowData[dataKey]}</Badge> : rowData[dataKey]}
          </Col>
        </Row>
      </Cell>
    );
  }

  return (
    <Row>
      <Col xs={24} className="mt-3">
        <div style={{ position: 'relative' }}>
          <Table
            onSortColumn={handleSortColumn}
            sortColumn={sortColumn}
            sortType={sortType || 'desc'}
            shouldUpdateScroll={false}
            autoHeight={true}
            data={hits}
            rowKey={rowKey}
            bordered={true}
            cellBordered={true}
            headerHeight={30}
          >
            <Column fixed="right" align='center'>
              <HeaderCell>...</HeaderCell>

              <Cell style={{ padding: '6px' }}>
                {
                  row => {
                    return (
                      <>
                        <Button appearance="link" onClick={() => setDataHeroForm(row)}><Icon as={FaFilePen} /></Button>
                        <Button appearance="link" onClick={() => dispatch(destroy_hero(row))}><Icon as={FaTrashCan} /></Button>
                      </>
                    )
                  }
                }
              </Cell>
            </Column>
            <Column align='center' sortable>
              <HeaderCell>RANK</HeaderCell>
              <Cell dataKey='rank'>
                {row => <Tag color={rankColors[row.rank]}>{row.rank}</Tag>}
              </Cell>
            </Column>
            <Column align='center' sortable>
              <HeaderCell>STATUS</HeaderCell>
              <Cell dataKey='status'>
                {row => <Col><Badge color={statusColors[row.status]} content={row.status} /></Col>}
              </Cell>
            </Column>
            <Column width={250} align='center' sortable>
              <HeaderCell>NAME</HeaderCell>
              <NameCell dataKey='name' />
            </Column>
            <Column flexGrow={1}>
              <HeaderCell>LOCATION</HeaderCell>
              <Cell>
                {row => {
                  return (
                    <TagGroup>
                      <Tag>{row.lat}</Tag>
                      <Tag>{row.lng}</Tag>
                      <IconButton
                        onClick={() => { navigator.clipboard.writeText(`${row.lat} ${row.lng}`) }}
                        appearance='subtle'
                        circle size="xs"
                        icon={<Icon as={FaClipboardCheck} />}
                      />
                    </TagGroup>
                  )
                }
                }
              </Cell>
            </Column>
          </Table>
        </div>
      </Col>
      <HeroForm size='xs' open={openUpdateHeroForm} textButton='Update' title='Update Hero' data={dataHeroForm} handleClose={() => setDataHeroForm({})} />
    </Row>
  )
}

export default List
