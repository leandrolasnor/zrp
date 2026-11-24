import { useSelector } from 'react-redux'
import { Badge } from '@mantine/core'
import { FaTrophy } from 'react-icons/fa6'
import { memo } from 'react'

const SuperHero = () => {
  const super_hero = useSelector(state => state.metrics.super_hero)
  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }

  if (super_hero) return (
    <Badge color={colors[super_hero.rank]} variant="light" leftSection={<FaTrophy />}>
      {super_hero.name}
    </Badge>
  )
  return null
}

export default memo(SuperHero)
