import { Row, Col, Panel, Tooltip } from 'rsuite'
import { Whisper, Progress } from 'rsuite'
import { styled } from 'styled-components'

const _ = require('lodash')

const heroes_s_count = metrics => _.get(metrics, ['heroes_grouped_rank', 's'])
const heroes_a_count = metrics => _.get(metrics, ['heroes_grouped_rank', 'a'])
const heroes_b_count = metrics => _.get(metrics, ['heroes_grouped_rank', 'b'])
const heroes_c_count = metrics => _.get(metrics, ['heroes_grouped_rank', 'c'])

const heroes_working_count = metrics => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (JSON.stringify(key).match(/working/)) return sum + parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)

const heroes_s_working_count = metrics => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (JSON.parse(key).join('-').match(/s-working/)) return sum + parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)
const heroes_a_working_count = metrics => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (JSON.parse(key).join('-').match(/a-working/)) return sum + parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)
const heroes_b_working_count = metrics => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (JSON.parse(key).join('-').match(/b-working/)) return sum + parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)
const heroes_c_working_count = metrics => Object.keys(_.get(metrics, 'heroes_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (JSON.parse(key).join('-').match(/c-working/)) return sum + parseFloat(_.get(metrics, ['heroes_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)

const heroes_working_percent = metrics => (heroes_working_count(metrics) / hero_count(metrics)) * 100
const heroes_s_working_percent = metrics => (heroes_s_working_count(metrics) / heroes_s_count(metrics)) * 100
const heroes_a_working_percent = metrics => (heroes_a_working_count(metrics) / heroes_a_count(metrics)) * 100
const heroes_b_working_percent = metrics => (heroes_b_working_count(metrics) / heroes_b_count(metrics)) * 100
const heroes_c_working_percent = metrics => (heroes_c_working_count(metrics) / heroes_c_count(metrics)) * 100
const hero_count = metrics => _.get(metrics, 'hero_count', 0)

const s_tooltip = <Tooltip><i>S</i></Tooltip>
const a_tooltip = <Tooltip><i>A</i></Tooltip>
const b_tooltip = <Tooltip><i>B</i></Tooltip>
const c_tooltip = (<Tooltip><i>C</i></Tooltip>)

const HeroesWorking = props => {
  const { metrics } = props

  return (
    <Panel shaded bordered bodyFill>
      <Row>
        <Col className='mt-3 ms-4' sm={8}>
          <Progress.Circle percent={~~Number(heroes_working_percent(metrics).toFixed(0)) || 0} strokeColor="#ffdb58" />
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={s_tooltip}>
            <Progress.Circle percent={~~Number(heroes_s_working_percent(metrics).toFixed(0)) || 0} status="active" strokeColor="#2986cc" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={a_tooltip}>
            <Progress.Circle percent={~~Number(heroes_a_working_percent(metrics).toFixed(0)) || 0} status="active" strokeColor="#0AB653" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={b_tooltip}>
            <Progress.Circle percent={~~Number(heroes_b_working_percent(metrics).toFixed(0)) || 0} status="active" strokeColor="#a442f5" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={c_tooltip}>
            <Progress.Circle percent={~~Number(heroes_c_working_percent(metrics).toFixed(0)) || 0} status="active" strokeColor="#ff0000" />
          </Whisper>
        </Col>
      </Row>
      <Panel header={`${heroes_working_count(metrics) || 0} Working`}>
        <p>
          <small>
            Percentage of busy heroes
          </small>
        </p>
      </Panel>
    </Panel>
  )
}


export default HeroesWorking
