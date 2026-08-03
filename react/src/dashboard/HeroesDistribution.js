import { useSelector } from 'react-redux'
import { Tag, Col, Badge } from 'rsuite'
import { memo } from 'react'
import _ from 'lodash'

const HeroesDistribution = () => {
  const heroes_distribution = useSelector(state => state.metrics.heroes_distribution)
  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }

  if (heroes_distribution) return (
    <Col>
      {
        Object.entries(colors).map(([rank, color]) => {
          return (
            <Col key={rank}>
              <Badge color={color} content={heroes_distribution[rank.toLowerCase()]}>
                <Tag>{rank.toUpperCase()}</Tag>
              </Badge>
            </Col>
          )
        })
      }
    </Col>
  )
}

export default memo(HeroesDistribution)
