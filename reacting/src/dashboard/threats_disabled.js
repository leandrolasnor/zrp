import { Tooltip, Whisper, Tag, Progress, Panel, Row, Col } from 'rsuite'

const _ = require('lodash')

const god_tooltip = <Tooltip><i>God</i></Tooltip>
const dragon_tooltip = <Tooltip><i>Dragon</i></Tooltip>
const tiger_tooltip = <Tooltip><i>Tiger</i></Tooltip>
const wolf_tooltip = (<Tooltip><i>Wolf</i></Tooltip>)

const threat_count = metrics => _.get(metrics, 'threat_count', 0)
const threats_disabled = metrics => {
  const by_rank = _.get(metrics, ['threats_disabled_facets_rank', 'facetDistribution', 'rank'], {})
  const sum = Object.values(by_rank).reduce((r, v) => r + v, 0)
  return sum
}

const threats_god_disabled = metrics => _.get(metrics, ['threats_disabled_facets_rank', 'facetDistribution', 'rank', 'god'], 0)
const threats_dragon_disabled = metrics => _.get(metrics, ['threats_disabled_facets_rank', 'facetDistribution', 'rank', 'dragon'], 0)
const threats_tiger_disabled = metrics => _.get(metrics, ['threats_disabled_facets_rank', 'facetDistribution', 'rank', 'tiger'], 0)
const threats_wolf_disabled = metrics => _.get(metrics, ['threats_disabled_facets_rank', 'facetDistribution', 'rank', 'wolf'], 0)

const threats_god = metrics => _.get(metrics, ['threats_facets_rank', 'facetDistribution', 'rank', 'god'], 0)
const threats_dragon = metrics => _.get(metrics, ['threats_facets_rank', 'facetDistribution', 'rank', 'dragon'], 0)
const threats_tiger = metrics => _.get(metrics, ['threats_facets_rank', 'facetDistribution', 'rank', 'tiger'], 0)
const threats_wolf = metrics => _.get(metrics, ['threats_facets_rank', 'facetDistribution', 'rank', 'wolf'], 0)

const threats_disabled_percent = metrics => (threats_disabled(metrics) / threat_count(metrics)) * 100
const threats_god_disabled_percent = metrics => (threats_god_disabled(metrics) / threats_god(metrics)) * 100
const threats_dragon_disabled_percent = metrics => (threats_dragon_disabled(metrics) / threats_dragon(metrics)) * 100
const threats_tiger_disabled_percent = metrics => (threats_tiger_disabled(metrics) / threats_tiger(metrics)) * 100
const threats_wolf_disabled_percent = metrics => (threats_wolf_disabled(metrics) / threats_wolf(metrics)) * 100

const ThreatsDisabled = props => {
  const { metrics } = props

  return (
    <Panel bodyFill>
      <Row>
        <Col className="mt-3 ms-4" sm={8}>
          <Progress.Circle percent={~~Number(threats_disabled_percent(metrics).toFixed(0)) || 0} strokeColor="#ffdb58" />
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={god_tooltip}>
            <Progress.Circle percent={~~Number(threats_god_disabled_percent(metrics).toFixed(0)) || 0} status="active" strokeColor="#2986cc" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={dragon_tooltip}>
            <Progress.Circle percent={~~Number(threats_dragon_disabled_percent(metrics).toFixed(0)) || 0} status="active" strokeColor="#0AB653" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={tiger_tooltip}>
            <Progress.Circle percent={~~Number(threats_tiger_disabled_percent(metrics).toFixed(0)) || 0} status="active" strokeColor="#a442f5" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={wolf_tooltip}>
            <Progress.Circle percent={~~Number(threats_wolf_disabled_percent(metrics).toFixed(0)) || 0} status="active" strokeColor="#ff0000" />
          </Whisper>
        </Col>
      </Row>
      <Panel header={`${threats_disabled(metrics)} Disabled`}>
        <p>
          <small>
            Percentage of disabled threats
          </small>
        </p>
      </Panel>
    </Panel>
  )
}

export default ThreatsDisabled
