import { useSelector } from 'react-redux'
import { Tag, Col, Badge } from 'rsuite'

var _ = require('lodash');

const ThreatsDistribution = () => {
  const { threats_distribution } = useSelector(state => state.metrics)
  const colors = {
    god: 'blue',
    dragon: 'green',
    tiger: 'violet',
    wolf: 'red'
  }

  if (threats_distribution) return (
    <Col>
      {
        Object.entries(colors).map(([rank, color], i) => {
          return (
            <Col key={i}>
              <Badge color={color} content={threats_distribution[rank.toLocaleLowerCase()]}>
                <Tag>{_.capitalize(rank)}</Tag>
              </Badge>
            </Col>
          )
        })
      }
    </Col>
  )
}

export default ThreatsDistribution
