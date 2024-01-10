import { Row, Col, Card } from 'react-bootstrap'
import { Tag, Progress } from 'rsuite'
import { styled } from 'styled-components'

const _ = require('lodash')

const StyledCircleProgress = styled(Progress.Circle)`
  width: 120,
  display: 'inline-block',
  marginRight: 10
`;

const HeroesWorking = props => {
  const { metrics } = props
  const hero_count = () => _.get(metrics, 'hero_count', 0)
  const heroes_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.stringify(key).match(/working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )

  const heroes_s_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/s-working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const heroes_a_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/a-working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const heroes_b_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/b-working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const heroes_c_working_count = () => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/c-working/)) return sum+parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const heroes_s_count = () => _.get(metrics , ['heroes_grouped_rank', 's'])
  const heroes_a_count = () => _.get(metrics , ['heroes_grouped_rank', 'a'])
  const heroes_b_count = () => _.get(metrics , ['heroes_grouped_rank', 'b'])
  const heroes_c_count = () => _.get(metrics , ['heroes_grouped_rank', 'c'])

  const heroes_working_percent = () => (heroes_working_count() / hero_count()) * 100
  const heroes_s_working_percent = () => (heroes_s_working_count() / heroes_s_count()) * 100
  const heroes_a_working_percent = () => (heroes_a_working_count() / heroes_a_count()) * 100
  const heroes_b_working_percent = () => (heroes_b_working_count() / heroes_b_count()) * 100
  const heroes_c_working_percent = () => (heroes_c_working_count() / heroes_c_count()) * 100

  return(
    <Card>
      <Card.Body>
        <Card.Title>Heroes</Card.Title>
        <Card.Subtitle className="mb-0 text-muted">{`${heroes_working_count() || 0} Working`}</Card.Subtitle>
        <Row>
          <Col className='mt-4' sm={5}>
            <StyledCircleProgress strokeWidth={6} percent={Number(heroes_working_percent().toFixed(0))} strokeColor="#395463" />
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line strokeWidth={22} vertical percent={Number(heroes_s_working_percent().toFixed(0))} status="active" strokeColor="#2986cc" />
            <Tag color="blue">S</Tag>
          </Col>
          <Col sm={1} className='ms-3' >
            <Progress.Line strokeWidth={22} vertical percent={Number(heroes_a_working_percent().toFixed(0))} status="active" strokeColor="#0AB653" />
            <Tag color="green">A</Tag>
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line strokeWidth={22} vertical percent={Number(heroes_b_working_percent().toFixed(0))} status="active" strokeColor="#a442f5" />
            <Tag color="violet">B</Tag>
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line strokeWidth={22} vertical percent={Number(heroes_c_working_percent().toFixed(0))} status="active" strokeColor="#ff0000" />
            <Tag color="red">C</Tag>
          </Col>
        </Row>
      </Card.Body>
    </Card>
  )
}


export default HeroesWorking
