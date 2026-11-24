import { Paper, Group, RingProgress, Text, Tooltip, Box, Stack } from '@mantine/core'
import { useSelector } from 'react-redux'
import HeroesDistribution from './HeroesDistribution'
import { memo } from 'react'
import _ from 'lodash'

const HeroesWorking = () => {
  const heroes_working = useSelector(state => state.metrics.heroes_working)

  const g = _.get(heroes_working, 'global', 0)

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
          <Tooltip label={<i>S</i>}>
            <RingProgress size={60} thickness={8} sections={[{ value: _.get(heroes_working, 's', 0), color: 'blue' }]} />
          </Tooltip>
          <Tooltip label={<i>A</i>}>
            <RingProgress size={60} thickness={8} sections={[{ value: _.get(heroes_working, 'a', 0), color: 'green' }]} />
          </Tooltip>
          <Tooltip label={<i>B</i>}>
            <RingProgress size={60} thickness={8} sections={[{ value: _.get(heroes_working, 'b', 0), color: 'violet' }]} />
          </Tooltip>
          <Tooltip label={<i>C</i>}>
            <RingProgress size={60} thickness={8} sections={[{ value: _.get(heroes_working, 'c', 0), color: 'red' }]} />
          </Tooltip>
        </Group>
      </Group>
      <Box mt="md">
        <Text fw={600} mb="xs">{_.get(heroes_working, 'count', 0)} Working</Text>
        <HeroesDistribution />
      </Box>
    </Paper>
  )
}

export default memo(HeroesWorking)
