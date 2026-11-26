import { Badge, Box, Group, Paper, RingProgress, Text } from '@mantine/core'
import { useSelector } from 'react-redux'
import { memo } from 'react'

const colors = ['#34c3ff', '#1464ac']

const BattlesCharts = () => {
  const battles_lineup = useSelector(state => state.metrics.battles_lineup)

  const lineup = (Array.isArray(battles_lineup) ? battles_lineup : [])
    .map(([name, value]) => [name, Number(value) || 0])
  const total = lineup.reduce((sum, [, value]) => sum + value, 0)

  const percentage = value => (total > 0 ? (value / total) * 100 : 0)

  const sections = lineup.map(([, value], index) => ({
    value: percentage(value),
    color: colors[index % colors.length]
  }))

  return (
    <Paper withBorder p="md">
      <Group align="center" gap="lg">
        <RingProgress
          size={120}
          thickness={12}
          roundCaps
          sections={sections}
        />
      </Group>
      <Box mt="md">
        <Text c="dimmed" fw={600} mb="xs">{total} Battles</Text>
        <Group gap="xs">
          {lineup.map(([name, value], index) => (
            <Badge key={name} color={colors[index % colors.length]} variant="light">
              <Text component="span" inherit>{name}</Text>{' '}
              <Text component="span" inherit>{`${Math.round(percentage(value))}%`}</Text>
            </Badge>
          ))}
        </Group>
      </Box>
    </Paper>
  )
}

export default memo(BattlesCharts)
