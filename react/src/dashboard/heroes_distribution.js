import { useSelector } from 'react-redux'
import { Tag, Col, Badge } from 'rsuite'
const _ = require('lodash');

const HeroesDistribution = () => {
  const { heroes_distribution } = useSelector(state => state.metrics)
  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }

  if (heroes_distribution) return (
    <Col>
      {
        Object.entries(colors).map(([rank, color], i) => {
          return (
            <Col key={i}>
              <Badge color={color} content={heroes_distribution[rank.toLocaleLowerCase()]}>
                <Tag>{rank.toUpperCase()}</Tag>
              </Badge>
            </Col>
          )})
      }
    </Col>
  )
}

export default HeroesDistribution
