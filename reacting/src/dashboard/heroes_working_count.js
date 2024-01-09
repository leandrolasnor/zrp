import { useSelector } from 'react-redux'
import { Row, Col, Card } from 'react-bootstrap'
import { Tag, Progress } from 'rsuite'
import { styled } from 'styled-components'

const _ = require('lodash')

const StyledCircleProgress = styled(Progress.Circle)`
  width: 120,
  display: 'inline-block',
  marginRight: 10
`;

const HeroesWorkingCount = () => {
  const { metrics } = useSelector(state => state.metrics)

  const hero_count = () => _.get(metrics, 'hero_count', 0)
  const heroes_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped', {})).reduce(
    (sum,key)=> {
      if(JSON.stringify(key).match(/working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped', `${key}`], 0)||0)
      return sum
    }, 0
  )
  
  const heroes_s_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/s-working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const heroes_a_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/a-working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const heroes_b_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/b-working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const heroes_c_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/c-working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped', `${key}`], 0)||0)
      return sum
    }, 0
  )
  
  const heroes_working_percent = () => (heroes_working_count() / hero_count()) * 100
  const heroes_s_working_percent = () => (heroes_s_working_count() / hero_count()) * 100
  const heroes_a_working_percent = () => (heroes_a_working_count() / hero_count()) * 100
  const heroes_b_working_percent = () => (heroes_b_working_count() / hero_count()) * 100
  const heroes_c_working_percent = () => (heroes_c_working_count() / hero_count()) * 100

  return(
    <Card>
      <Card.Body>
        <Card.Title>Heroes</Card.Title>
        <Card.Subtitle className="mb-2 text-muted">{`${heroes_working_count() || 0} Working`}</Card.Subtitle>
        <Row>
          <Col sm={5}>
            <StyledCircleProgress percent={heroes_working_percent().toFixed(0)} strokeColor="#ffc107" />
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line vertical percent={heroes_s_working_percent().toFixed(0)} status="active" strokeColor="#4287f5" />
            <Tag color="blue">S</Tag>
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line vertical percent={heroes_a_working_percent().toFixed(0)} status="active" strokeColor="#7bf542" />
            <Tag color="#4287f5">A</Tag>
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line vertical percent={heroes_b_working_percent().toFixed(0)} status="active" strokeColor="#a442f5" />
            <Tag color="#4287f5">B</Tag>
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line vertical percent={heroes_c_working_percent().toFixed(0)} status="active" strokeColor="#f54260" />
            <Tag color="#4287f5">C</Tag>
          </Col>
        </Row>
      </Card.Body>
    </Card>
  )
}


export default HeroesWorkingCount
