import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Table, Button, Badge, Group, Paper, Text, Loader, ActionIcon } from '@mantine/core'
import { FaTrashCan, FaFilePen, FaTrophy, FaClipboardCheck } from 'react-icons/fa6'
import HeroForm from './HeroForm'
import { destroy_hero } from './actions'
import _ from 'lodash'
import PropTypes from 'prop-types'

const List = () => {
  const dispatch = useDispatch()
  const { search: { hits, query, filter }, loading } = useSelector(state => state.heroes)
  const super_hero = useSelector(state => state.metrics.super_hero)
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
    working: 'yellow',
    disable: 'red'
  }
  const rankColors = {
    s: 'cyan',
    a: 'green',
    b: 'violet',
    c: 'red'
  }

  const renderSortIndicator = (col) => {
    if (sortColumn !== col) return null
    return sortType === 'asc' ? ' ▲' : ' ▼'
  }

  const thStyle = { cursor: 'pointer' }

  return (
    <div style={{ marginTop: 12 }}>
      <div style={{ position: 'relative' }}>
        {loading ? (
          <div style={{ padding: 40, textAlign: 'center' }}><Loader /></div>
        ) : hits.length === 0 ? (
          <Paper withBorder p="xl" style={{ textAlign: 'center' }}>
            <Text c="dimmed">No heroes found</Text>
          </Paper>
        ) : (
          <Table striped highlightOnHover withTableBorder withColumnBorders>
            <Table.Thead>
              <Table.Tr>
                <Table.Th>...</Table.Th>
                <Table.Th style={thStyle} onClick={() => handleSortColumn('rank', sortColumn === 'rank' && sortType === 'asc' ? 'desc' : 'asc')}>RANK{renderSortIndicator('rank')}</Table.Th>
                <Table.Th style={thStyle} onClick={() => handleSortColumn('status', sortColumn === 'status' && sortType === 'asc' ? 'desc' : 'asc')}>STATUS{renderSortIndicator('status')}</Table.Th>
                <Table.Th style={thStyle} onClick={() => handleSortColumn('name', sortColumn === 'name' && sortType === 'asc' ? 'desc' : 'asc')}>NAME{renderSortIndicator('name')}</Table.Th>
                <Table.Th>LOCATION</Table.Th>
              </Table.Tr>
            </Table.Thead>
            <Table.Tbody>
              {hits.map((row) => (
                <Table.Tr key={row.id}>
                  <Table.Td>
                    <Group gap="xs" wrap="nowrap">
                      <ActionIcon variant="subtle" onClick={() => setDataHeroForm(row)}><FaFilePen /></ActionIcon>
                      <ActionIcon variant="subtle" color="red" onClick={() => dispatch(destroy_hero(row))}><FaTrashCan /></ActionIcon>
                    </Group>
                  </Table.Td>
                  <Table.Td><Badge color={rankColors[row.rank]} variant="light">{row.rank}</Badge></Table.Td>
                  <Table.Td><Badge color={statusColors[row.status]} variant="light">{row.status}</Badge></Table.Td>
                  <Table.Td>
                    {_.get(super_hero, 'name', '') === row.name ? (
                      <Badge color="orange" variant="light" leftSection={<FaTrophy />}>{row.name}</Badge>
                    ) : row.name}
                  </Table.Td>
                  <Table.Td>
                    <Group gap="xs">
                      <Badge variant="outline">{row.lat}</Badge>
                      <Badge variant="outline">{row.lng}</Badge>
                      <ActionIcon variant="subtle" size="sm" onClick={() => { navigator.clipboard.writeText(`${row.lat} ${row.lng}`) }}>
                        <FaClipboardCheck />
                      </ActionIcon>
                    </Group>
                  </Table.Td>
                </Table.Tr>
              ))}
            </Table.Tbody>
          </Table>
        )}
      </div>
      <HeroForm size='xs' open={openUpdateHeroForm} textButton='Update' title='Update Hero' data={dataHeroForm} handleClose={() => setDataHeroForm({})} />
    </div>
  )
}

export default List
