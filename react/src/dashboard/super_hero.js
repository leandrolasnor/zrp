import { useSelector } from 'react-redux'
import { Tag, Badge } from 'rsuite'

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
      <Badge color={colors[super_hero.rank]} content={super_hero.rank}>
        {super_hero.name}
      </Badge>
    </Tag>
  )
}

export default SuperHero
