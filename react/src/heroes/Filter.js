import { useState, useEffect, useMemo } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Accordion, Badge, Select, Group, Button } from '@mantine/core'
import { FaFilter } from 'react-icons/fa6'
import { get_statuses } from './actions'

const Filter = () => {
  const { ranks, statuses, search: { filter } } = useSelector(state => state.heroes)
  const dispatch = useDispatch()
  const parseFilter = (filterArr) => {
    let rank = null, status = null
    ;(filterArr || []).forEach(f => {
      const rMatch = String(f).match(/rank\s*=\s*'([^']+)'/)
      const sMatch = String(f).match(/status\s*=\s*'([^']+)'/)
      if (rMatch) rank = rMatch[1]
      if (sMatch) status = sMatch[1]
    })
    return { rank, status }
  }
  const [opened, setOpened] = useState(() => (filter && filter.length > 0))
  const [rankFilter, setRankFilter] = useState(() => parseFilter(filter).rank)
  const [statusFilter, setStatusFilter] = useState(() => parseFilter(filter).status)

  useEffect(() => { if (statuses?.length === 0) dispatch(get_statuses()) }, [statuses, dispatch])

  useEffect(() => {
    if (!filter || filter.length === 0) {
      setOpened(false)
      setRankFilter(null)
      setStatusFilter(null)
    }
  }, [filter])

  const rankColors = { s: 'cyan', a: 'green', b: 'violet', c: 'red' }
  const statusColors = { enabled: 'green', working: 'yellow', disable: 'red' }
  const ranksData = useMemo(() =>
    ranks.map((r) => ({ label: r.toUpperCase(), value: r })).reverse(),
    [ranks]
  )
  const statusesData = useMemo(() =>
    statuses.map((s) => ({ label: s, value: s })).reverse(),
    [statuses]
  )

  const applyFilter = () => {
    let f = []
    if (rankFilter) f.push(`rank = '${rankFilter}'`)
    if (statusFilter) f.push(`status = '${statusFilter}'`)
    dispatch({ type: 'SET_FILTER', payload: f })
    dispatch({ type: 'FOCUS_SEARCH_INPUT' })
  }

  const handleAccordionChange = (val) => {
    if (!val && opened) {
      setStatusFilter(null)
      setRankFilter(null)
      if (filter.length) dispatch({ type: 'CLEAR_FILTER' })
    }
    setOpened(!!val)
  }

  return (
    <div style={{ marginTop: 12 }}>
      <Accordion value={opened ? 'filter' : null} onChange={handleAccordionChange}>
        <Accordion.Item value="filter">
          <Accordion.Control>Filter</Accordion.Control>
          <Accordion.Panel>
            <Group mt="sm" align="flex-end">
              <Select
                placeholder="Rank"
                data={ranksData}
                value={rankFilter}
                onChange={setRankFilter}
                clearable
                searchable={false}
                style={{ minWidth: 150 }}
                styles={{ input: { color: rankFilter ? `var(--mantine-color-${rankColors[rankFilter] || 'gray'}-6)` : undefined, fontWeight: 700 } }}
                renderOption={({ option }) => (
                  <Badge color={rankColors[option.value] || 'gray'} variant="light">{option.value.toUpperCase()}</Badge>
                )}
              />
              <Select
                placeholder="Status"
                data={statusesData}
                value={statusFilter}
                onChange={setStatusFilter}
                clearable
                searchable={false}
                style={{ minWidth: 150 }}
                styles={{ input: { color: statusFilter ? `var(--mantine-color-${statusColors[statusFilter] || 'gray'}-6)` : undefined, fontWeight: 700 } }}
                renderOption={({ option }) => (
                  <Badge color={statusColors[option.value] || 'gray'} variant="light">{option.value}</Badge>
                )}
              />
              <Button onClick={applyFilter} leftSection={<FaFilter />}>Apply</Button>
            </Group>
          </Accordion.Panel>
        </Accordion.Item>
      </Accordion>
    </div>
  )
}

export default Filter
