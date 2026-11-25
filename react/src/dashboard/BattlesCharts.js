import { Box, Group, Paper, RingProgress, Stack, Text } from '@mantine/core'
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
      <Stack align="center" gap="sm">
        <RingProgress
          size={160}
          thickness={12}
          sections={sections}
        />
        <Group gap="md" justify="center">
          {lineup.map(([name, value], index) => (
            <Group key={name} gap="xs" wrap="nowrap">
              <Box
                w={10}
                h={10}
                bg={colors[index % colors.length]}
                style={{ borderRadius: '50%' }}
              />
              <Text size="sm">{name}</Text>
              <Text size="sm" c="dimmed">{`${Math.round(percentage(value))} %`}</Text>
            </Group>
          ))}
        </Group>
      </Stack>
    </Paper>
  )
}

export default memo(BattlesCharts)
