import { useSelector } from 'react-redux'
import { Tag, Badge } from 'rsuite'
import { Icon } from '@rsuite/icons'
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
    <Tag>
      <Badge color={colors[super_hero.rank]} content={<Icon as={FaTrophy} />}>
        {super_hero.name}
      </Badge>
    </Tag>
  )
}

export default memo(SuperHero)
