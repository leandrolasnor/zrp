import { Fragment, useEffect, useState, memo } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { ActionIcon, Badge, Box, Group, Loader, Paper, Table, Text, Tooltip } from '@mantine/core'
import { historical_threats as historical } from './actions.js'
import { FaArrowRotateRight, FaBoxOpen, FaChevronDown, FaChevronRight } from 'react-icons/fa6'
import PropTypes from 'prop-types'

const rankColors = {
  god: 'blue',
  dragon: 'green',
  tiger: 'violet',
  wolf: 'red'
}

const heroRankColors = {
  s: 'blue',
  a: 'green',
  b: 'violet',
  c: 'red'
}

const formatDuration = duration => {
  const hours = Number(duration?.hours) || 0
  const minutes = Number(duration?.minutes) || 0
  const seconds = Number(duration?.seconds) || 0
  return `${hours.toFixed(0)}h ${minutes.toFixed(2)}min ${seconds.toFixed(2)}sec`
}

const BattleHeroes = ({ heroes }) => (
  <Group gap="xs">
    {(heroes ?? []).map(hero => (
      <Group key={`${hero.name}-${hero.rank}`} gap={4}>
        <Badge color={heroRankColors[hero.rank]} variant="light">
          {hero.rank.toUpperCase()}
        </Badge>
        <Text size="sm">{hero.name}</Text>
      </Group>
    ))}
  </Group>
)

BattleHeroes.propTypes = {
  heroes: PropTypes.arrayOf(PropTypes.shape({
    name: PropTypes.string,
    rank: PropTypes.string
  }))
}

const HistoricalThreats = () => {
  const historical_threats = useSelector(state => state.metrics.historical_threats) ?? []
  const count = useSelector(state => state.metrics.threats_disabled.count)
  const dispatch = useDispatch()
  const [loading, setLoading] = useState(true)
  const [expandedRowKeys, setExpandedRowKeys] = useState([])

  useEffect(() => {
    let active = true
    dispatch(historical({ page: 1, per_page: 50 })).then(() => {
      if (active) setLoading(false)
    })
    return () => { active = false }
  }, [count, dispatch])

  const refresh = () => dispatch(historical({ page: 1, per_page: 50 }))

  const toggleRow = id => setExpandedRowKeys(current => (
    current.includes(id) ? current.filter(key => key !== id) : [...current, id]
  ))

  if (loading) return (
    <Paper withBorder p="xl">
      <Group justify="center" gap="sm">
        <Loader size="sm" />
        <Text c="dimmed">Loading historical threats...</Text>
      </Group>
    </Paper>
  )

  if (historical_threats.length === 0) return (
    <Paper withBorder p="xl" ta="center">
      <FaBoxOpen size={64} opacity={0.3} />
      <Text c="dimmed" mt="sm">No historical threats yet</Text>
    </Paper>
  )

  return (
    <Box style={{ overflowX: 'auto' }}>
      <Table withTableBorder withColumnBorders highlightOnHover verticalSpacing="xs" horizontalSpacing="sm">
        <Table.Thead>
          <Table.Tr>
            <Table.Th>
              <Tooltip label="Refresh historical threats">
                <ActionIcon
                  variant="subtle"
                  size="sm"
                  aria-label="Refresh historical threats"
                  onClick={refresh}
                >
                  <FaArrowRotateRight />
                </ActionIcon>
              </Tooltip>
            </Table.Th>
            <Table.Th>NAME</Table.Th>
            <Table.Th>LOCATION</Table.Th>
            <Table.Th>INITIAL DATE</Table.Th>
            <Table.Th>FINISH DATE</Table.Th>
          </Table.Tr>
        </Table.Thead>
        <Table.Tbody>
          {historical_threats.map(threat => {
            const expanded = expandedRowKeys.includes(threat.id)
            const battle = threat.battle ?? {}

            return (
              <Fragment key={threat.id}>
                <Table.Tr>
                  <Table.Td>
                    <ActionIcon
                      variant="subtle"
                      size="sm"
                      aria-label={`${expanded ? 'Collapse' : 'Expand'} ${threat.name}`}
                      onClick={() => toggleRow(threat.id)}
                    >
                      {expanded ? <FaChevronDown /> : <FaChevronRight />}
                    </ActionIcon>
                  </Table.Td>
                  <Table.Td>
                    <Group gap="xs" wrap="nowrap">
                      <Text size="sm">{threat.name}</Text>
                      <Badge color={rankColors[threat.rank]} variant="light">
                        {threat.rank}
                      </Badge>
                    </Group>
                  </Table.Td>
                  <Table.Td>
                    <Group gap={4}>
                      <Badge color="gray" variant="light">{threat.lat}</Badge>
                      <Badge color="gray" variant="light">{threat.lng}</Badge>
                    </Group>
                  </Table.Td>
                  <Table.Td><Text size="sm">{battle.created_at ?? '-'}</Text></Table.Td>
                  <Table.Td><Text size="sm">{battle.finished_at ?? '-'}</Text></Table.Td>
                </Table.Tr>
                {expanded && (
                  <Table.Tr data-testid={`battle-details-${threat.id}`}>
                    <Table.Td colSpan={5}>
                      <Group gap="lg" wrap="wrap">
                        <Text size="sm">
                          <Text component="span" fw={600}>Score:</Text> {battle.score}
                        </Text>
                        <BattleHeroes heroes={battle.heroes} />
                        <Text size="sm">
                          <Text component="span" fw={600}>Duration:</Text> {formatDuration(battle.duration)}
                        </Text>
                      </Group>
                    </Table.Td>
                  </Table.Tr>
                )}
              </Fragment>
            )
          })}
        </Table.Tbody>
      </Table>
    </Box>
  )
}

export default memo(HistoricalThreats)
