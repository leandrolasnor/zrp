import { useSelector } from 'react-redux'
import { Badge, Group } from '@mantine/core'
import { memo } from 'react'

const HeroesDistribution = () => {
  const heroes_distribution = useSelector(state => state.metrics.heroes_distribution)
  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }

  if (heroes_distribution) return (
    <Group gap="xs">
      {
        Object.entries(colors).map(([rank, color]) => {
          return (
            <Badge key={rank} color={color} variant="light">
              {rank.toUpperCase()}: {heroes_distribution[rank.toLowerCase()]}
            </Badge>
          )
        })
      }
    </Group>
  )
  return null
}

export default memo(HeroesDistribution)
