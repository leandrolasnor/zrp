import { Tag, Badge } from 'rsuite'

const SuperHero = props => {
  const { hero } = props
  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }

  if (hero) return (
    <Tag>
      <Badge color={colors[hero.rank]} content={hero.rank}>
        {hero.name}
      </Badge>
    </Tag>
  )
}

export default SuperHero
