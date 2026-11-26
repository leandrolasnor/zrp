import { Paper, Group, RingProgress, Text, Tooltip, Box } from '@mantine/core'
import { useSelector } from 'react-redux'
import ThreatsDistribution from './ThreatsDistribution'
import { memo } from 'react'
import _ from 'lodash'

const ThreatsDisabled = () => {
  const threats_disabled = useSelector(state => state.metrics.threats_disabled)
  const g = _.get(threats_disabled, 'global', 0)

  return (
    <Paper withBorder p="md">
      <Group align="center" gap="lg">
        <RingProgress
          size={120}
          thickness={12}
          sections={[{ value: g, color: 'yellow' }]}
          label={<Text ta="center" fw={700}>{g}%</Text>}
        />
        <Group gap="md">
          <Tooltip label={<i>God</i>}>
            <RingProgress size={60} thickness={8} sections={[{ value: _.get(threats_disabled, 'god', 0), color: 'blue' }]} />
          </Tooltip>
          <Tooltip label={<i>Dragon</i>}>
            <RingProgress size={60} thickness={8} sections={[{ value: _.get(threats_disabled, 'dragon', 0), color: 'green' }]} />
          </Tooltip>
          <Tooltip label={<i>Tiger</i>}>
            <RingProgress size={60} thickness={8} sections={[{ value: _.get(threats_disabled, 'tiger', 0), color: 'violet' }]} />
          </Tooltip>
          <Tooltip label={<i>Wolf</i>}>
            <RingProgress size={60} thickness={8} sections={[{ value: _.get(threats_disabled, 'wolf', 0), color: 'red' }]} />
          </Tooltip>
        </Group>
      </Group>
      <Box mt="md">
        <Text c="dimmed" fw={600} mb="xs">{_.get(threats_disabled, 'count', 0)} Disabled</Text>
        <ThreatsDistribution />
      </Box>
    </Paper>
  )
}

export default memo(ThreatsDisabled)
