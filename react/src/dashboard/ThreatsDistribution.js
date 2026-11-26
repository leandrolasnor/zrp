import { useSelector } from 'react-redux'
import { Badge, Group } from '@mantine/core'
import { memo } from 'react'
import _ from 'lodash'

const ThreatsDistribution = () => {
  const threats_distribution = useSelector(state => state.metrics.threats_distribution)
  const colors = {
    god: 'blue',
    dragon: 'green',
    tiger: 'violet',
    wolf: 'red'
  }

  if (threats_distribution) return (
    <Group gap="xs">
      {
        Object.entries(colors).map(([rank, color]) => {
          return (
            <Badge key={rank} color={color} variant="light">
              {_.capitalize(rank)}: {threats_distribution[rank.toLowerCase()] ?? 0}
            </Badge>
          )
        })
      }
    </Group>
  )
  return null
}

export default memo(ThreatsDistribution)
