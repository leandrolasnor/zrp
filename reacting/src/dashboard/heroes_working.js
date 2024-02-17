import { Row, Col, Panel, Tooltip } from 'rsuite'
import { Whisper, Progress } from 'rsuite'
import { styled } from 'styled-components'

const _ = require('lodash')

const heroes_s = metrics => _.get(metrics, ['heroes_facets_rank', 'facetDistribution', 'rank', 's'], 0)
const heroes_a = metrics => _.get(metrics, ['heroes_facets_rank', 'facetDistribution', 'rank', 'a'], 0)
const heroes_b = metrics => _.get(metrics, ['heroes_facets_rank', 'facetDistribution', 'rank', 'b'], 0)
const heroes_c = metrics => _.get(metrics, ['heroes_facets_rank', 'facetDistribution', 'rank', 'c'], 0)

const heroes = metrics => _.get(metrics, 'hero_count', 0)
const heroes_working = metrics => {
  const by_rank = _.get(metrics, ['heroes_working_facets_rank', 'facetDistribution', 'rank'], {})
  const sum = Object.values(by_rank).reduce((r, v) => r + v, 0)
  return sum
}

const heroes_s_working = metrics => _.get(metrics, ['heroes_working_facets_rank', 'facetDistribution', 'rank', 's'], 0)
const heroes_a_working = metrics => _.get(metrics, ['heroes_working_facets_rank', 'facetDistribution', 'rank', 'a'], 0)
const heroes_b_working = metrics => _.get(metrics, ['heroes_working_facets_rank', 'facetDistribution', 'rank', 'b'], 0)
const heroes_c_working = metrics => _.get(metrics, ['heroes_working_facets_rank', 'facetDistribution', 'rank', 'c'], 0)

const heroes_working_percent = metrics => (heroes_working(metrics) / heroes(metrics)) * 100
const heroes_s_working_percent = metrics => (heroes_s_working(metrics) / heroes_s(metrics)) * 100
const heroes_a_working_percent = metrics => (heroes_a_working(metrics) / heroes_a(metrics)) * 100
const heroes_b_working_percent = metrics => (heroes_b_working(metrics) / heroes_b(metrics)) * 100
const heroes_c_working_percent = metrics => (heroes_c_working(metrics) / heroes_c(metrics)) * 100

const s_tooltip = <Tooltip><i>S</i></Tooltip>
const a_tooltip = <Tooltip><i>A</i></Tooltip>
const b_tooltip = <Tooltip><i>B</i></Tooltip>
const c_tooltip = (<Tooltip><i>C</i></Tooltip>)

const HeroesWorking = props => {
  const { metrics } = props

  return (
    <Panel bodyFill>
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
      <Panel header={`${heroes_working(metrics) || 0} Working`}>
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
