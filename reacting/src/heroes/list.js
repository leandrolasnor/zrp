import { useState, useEffect } from 'react'
import { Table, Row, Col, Button } from 'rsuite'
import HeroForm from './hero_form'

const { Column, HeaderCell, Cell } = Table
const rowKey = 'id'

const List = props => {
  const { heroes: { search: { hits } } } = props
  const [openUpdateHeroForm, setOpenUpdateHeroForm] = useState(false)
  const [dataHeroForm, setDataHeroForm] = useState({})

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
            <Column width={80} fixed="right">
              <HeaderCell>...</HeaderCell>

              <Cell style={{ padding: '6px' }}>
                {rowData => (
                  <Button appearance="link" onClick={() => setDataHeroForm(rowData)}>
                    Edit
                  </Button>
                )}
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
