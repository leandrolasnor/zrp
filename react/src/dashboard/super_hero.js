import { useSelector } from 'react-redux'
import { Tag, Badge } from 'rsuite'
import { Icon } from '@rsuite/icons'
import { FaTrophy } from 'react-icons/fa6'

const SuperHero = () => {
  const { super_hero } = useSelector(state => state.metrics)
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

export default SuperHero
