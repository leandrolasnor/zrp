import { Row, Col, Card } from 'react-bootstrap'
import { Tooltip, Whisper, Tag, Progress } from 'rsuite'
import { styled } from 'styled-components'

const _ = require('lodash')

const StyledCircleProgress = styled(Progress.Circle)`
  width: 120,
  display: 'inline-block',
  marginRight: 10
`;

const god_tooltip = <Tooltip><i>God</i></Tooltip>
const dragon_tooltip = <Tooltip><i>Dragon</i></Tooltip>
const tiger_tooltip = <Tooltip><i>Tiger</i></Tooltip>
const wolf_tooltip = (<Tooltip><i>Wolf</i></Tooltip>)

const ThreatsDisabled = props => {
  const { metrics } = props
  const threat_count = () => _.get(metrics, 'threat_count', 0)
  const threats_disabled_count = () => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.stringify(key).match(/disabled/)) return sum+parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )

  const threats_god_disabled_count = () => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/god-disabled/)) return sum+parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const threats_dragon_disabled_count = () => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/dragon-disabled/)) return sum+parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const threats_tiger_disabled_count = () => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/tiger-disabled/)) return sum+parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const threats_wolf_disabled_count = () => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
    (sum,key)=> {
      if(JSON.parse(key).join('-').match(/wolf-disabled/)) return sum+parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0)||0)
      return sum
    }, 0
  )
  const threats_god_count = () => _.get(metrics , ['threats_grouped_rank', 'god'])
  const threats_dragon_count = () => _.get(metrics , ['threats_grouped_rank', 'dragon'])
  const threats_tiger_count = () => _.get(metrics , ['threats_grouped_rank', 'tiger'])
  const threats_wolf_count = () => _.get(metrics , ['threats_grouped_rank', 'wolf'])

  const threats_disabled_percent = () => (threats_disabled_count() / threat_count()) * 100
  const threats_god_disabled_percent = () => (threats_god_disabled_count() / threats_god_count()) * 100
  const threats_dragon_disabled_percent = () => (threats_dragon_disabled_count() / threats_dragon_count()) * 100
  const threats_tiger_disabled_percent = () => (threats_tiger_disabled_count() / threats_tiger_count()) * 100
  const threats_wolf_disabled_percent = () => (threats_wolf_disabled_count() / threats_wolf_count()) * 100

  return(
    <Card>
      <Card.Body>
        <Card.Title>Threats</Card.Title>
        <Card.Subtitle className="mb-0 text-muted">{`${threats_disabled_count()} Disabled`}</Card.Subtitle>
        <Row>
          <Col className="mt-4" sm={5}>
            <StyledCircleProgress strokeWidth={6} percent={~~Number(threats_disabled_percent().toFixed(0)) || 0} strokeColor="#a442f5" />
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line strokeWidth={22} vertical percent={~~Number(threats_god_disabled_percent().toFixed(0)) || 0} status="active" strokeColor="#2986cc" />

            <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={god_tooltip}>
              <Tag color="blue">G</Tag>
            </Whisper>
          </Col>
          <Col sm={1} className='ms-3' >
            <Progress.Line strokeWidth={22} vertical percent={~~Number(threats_dragon_disabled_percent().toFixed(0)) || 0} status="active" strokeColor="#0AB653" />
            <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={dragon_tooltip}>
              <Tag color="green">D</Tag>
            </Whisper>
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line strokeWidth={22} vertical percent={~~Number(threats_tiger_disabled_percent().toFixed(0)) || 0} status="active" strokeColor="#a442f5" />
            <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={tiger_tooltip}>
              <Tag color="violet">T</Tag>
            </Whisper>
          </Col>
          <Col sm={1} className='ms-3'>
            <Progress.Line strokeWidth={22} vertical percent={~~Number(threats_wolf_disabled_percent().toFixed(0)) || 0} status="active" strokeColor="#ff0000" />
            <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={wolf_tooltip}>
              <Tag color="red">W</Tag>
            </Whisper>
          </Col>
        </Row>
      </Card.Body>
    </Card>
  )
}

export default ThreatsDisabled
