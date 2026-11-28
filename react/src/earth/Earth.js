import { memo, useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { ActionIcon, Badge, Box, Divider, Group, Loader, Modal, Paper, Text, Tooltip } from '@mantine/core'
import { FaArrowRotateRight, FaBoxOpen } from 'react-icons/fa6'
import PropTypes from 'prop-types'
import { close_threat, fetch_earth_threats, hover_threat, rotate_earth, select_threat } from './actions'
import Globe from './Globe'
import ThreatTimeline from './ThreatTimeline'
import { VIEWBOX_SIZE } from './projection'

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
          {hero.rank?.toUpperCase()}
        </Badge>
        <Text size="sm">{hero.name}</Text>
      </Group>
    ))}
  </Group>
)

const Earth = () => {
  const dispatch = useDispatch()
  const { threats, hovered, selected, rotation, tilt } = useSelector(state => state.earth)
  const count = useSelector(state => state.metrics?.threats_disabled?.count)
  const [loading, setLoading] = useState(true)
  const [tooltipPoint, setTooltipPoint] = useState(null)

  useEffect(() => {
    let active = true
    dispatch(fetch_earth_threats({ page: 1, per_page: 50 })).then(() => {
      if (active) setLoading(false)
    })
    return () => { active = false }
  }, [count, dispatch])

  const refresh = () => dispatch(fetch_earth_threats({ page: 1, per_page: 50 }))

  const handleHover = (id, point) => {
    dispatch(hover_threat(id))
    setTooltipPoint(point ?? null)
  }

  const hoveredThreat = threats.find(threat => threat.id === hovered)
  const hoveredBattle = hoveredThreat?.battle ?? {}
  const battle = selected?.battle ?? {}

  return (
    <Paper withBorder p="md" data-testid="earth">
      <Group justify="space-between" mb="xs">
        <Text fw={600} c="dimmed">Threats around the globe</Text>
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
      </Group>

      <Box style={{ position: 'relative', maxWidth: 680, margin: '0 auto' }}>
        <Globe
          threats={threats}
          rotation={rotation}
          tilt={tilt}
          hovered={hovered}
          onHover={handleHover}
          onSelect={threat => dispatch(select_threat(threat))}
          onRotate={position => dispatch(rotate_earth(position))}
        />

        {(loading || threats.length === 0) && (
          <Box
            data-testid="earth-status"
            style={{
              position: 'absolute',
              inset: 0,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              pointerEvents: 'none'
            }}
          >
            <Paper withBorder shadow="sm" p="sm" radius="md">
              {loading ? (
                <Group justify="center" gap="sm">
                  <Loader size="sm" />
                  <Text c="dimmed">Loading historical threats...</Text>
                </Group>
              ) : (
                <Group justify="center" gap="sm">
                  <FaBoxOpen size={28} opacity={0.3} />
                  <Text c="dimmed">No historical threats yet</Text>
                </Group>
              )}
            </Paper>
          </Box>
        )}

        {hoveredThreat && tooltipPoint && (
          <Box
            data-testid="earth-tooltip"
            role="tooltip"
            style={{
              position: 'absolute',
              left: `${(tooltipPoint.x / VIEWBOX_SIZE) * 100}%`,
              top: `${(tooltipPoint.y / VIEWBOX_SIZE) * 100}%`,
              transform: 'translate(-50%, -115%)',
              pointerEvents: 'none',
              padding: '6px 10px',
              borderRadius: 6,
              background: '#1a1a1a',
              border: '1px solid #3b82f6',
              whiteSpace: 'nowrap'
            }}
          >
            <Group gap="xs">
              <Text size="xs" fw={600}>{hoveredThreat.name}</Text>
              <Badge color={rankColors[hoveredThreat.rank]} variant="light" size="xs">
                {hoveredThreat.rank}
              </Badge>
            </Group>
            <Text size="xs" c="dimmed">
              {hoveredThreat.lat}, {hoveredThreat.lng} · score {hoveredBattle.score ?? '-'}
            </Text>
          </Box>
        )}
      </Box>

      {!loading && threats.length > 0 && (
        <Text size="xs" c="dimmed" ta="center" mt="xs">
          Drag to rotate · hover for a summary · click a point for the full timeline
        </Text>
      )}

      <Modal
        opened={Boolean(selected)}
        onClose={() => dispatch(close_threat())}
        title={selected ? (
          <Group gap="xs">
            <Badge color={rankColors[selected.rank]} variant="light">{selected.rank}</Badge>
            <Text fw={600} data-testid="threat-title-name">{selected.name ?? 'Threat details'}</Text>
          </Group>
        ) : 'Threat details'}
        size="md"
      >
        {selected && (
          <Box data-testid="threat-details">
            <Text size="sm" c="dimmed" mb="sm">{selected.lat}, {selected.lng}</Text>

            <Box data-testid="threat-heroes" mb="sm">
              <BattleHeroes heroes={battle.heroes} />
            </Box>

            <Group gap="lg" wrap="wrap" mb="sm">
              <Box>
                <Text size="sm" fw={600}>Duration:</Text>
                <Text size="xs" c="dimmed">{formatDuration(battle.duration)}</Text>
              </Box>
              <Text size="sm">
                <Text component="span" fw={600}>Score:</Text>{' '}
                <Badge color="gray" variant="light" data-testid="threat-score">{battle.score ?? '-'}</Badge>
              </Text>
            </Group>

            <Group gap="lg" wrap="wrap" mb="sm">
              <Box>
                <Text size="sm" fw={600}>Started:</Text>
                <Text size="xs" c="dimmed">{battle.created_at ?? '-'}</Text>
              </Box>
              <Box>
                <Text size="sm" fw={600}>Finished:</Text>
                <Text size="xs" c="dimmed">{battle.finished_at ?? '-'}</Text>
              </Box>
            </Group>

            <Divider data-testid="threat-details-divider" my="sm" />

            <ThreatTimeline events={selected.events} />
          </Box>
        )}
      </Modal>
    </Paper>
  )
}

BattleHeroes.propTypes = {
  heroes: PropTypes.arrayOf(PropTypes.shape({
    name: PropTypes.string,
    rank: PropTypes.string
  }))
}

export default memo(Earth)
