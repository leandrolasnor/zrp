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

const List = props => {
  const dispatch = useDispatch()
  const { search: { hits } } = useSelector(state => state.heroes)
  const { super_hero } = useSelector(state => state.metrics)
  const [openUpdateHeroForm, setOpenUpdateHeroForm] = useState(false)
  const [dataHeroForm, setDataHeroForm] = useState({})
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
            <Badge color={statusColors[rowData.status]} content={rowData.status} />
          </Col>
          <Col>
            {_.get(super_hero, 'name', '') === rowData.name ? <Badge color='orange' content={<Icon as={FaTrophy} />}>{rowData[dataKey]}</Badge> : rowData[dataKey]}
          </Col>
        </Row>
      </Cell>
    );
  }

  useEffect(() => {
    setOpenUpdateHeroForm(Object.keys(dataHeroForm).length > 0)
  }, [dataHeroForm])

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
            <Column align='center'>
              <HeaderCell>RANK</HeaderCell>
              <Cell>
                {row => <Tag color={rankColors[row.rank]}>{row.rank}</Tag>}
              </Cell>
            </Column>
            <Column width={250} align='center'>
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
