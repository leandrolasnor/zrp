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
      <Badge color={colors[hero[1]]} content={hero[1]}>
        {hero[0]}
      </Badge>
    </Tag>
  )
}

export default SuperHero
