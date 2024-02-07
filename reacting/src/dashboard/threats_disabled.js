import { Tooltip, Whisper, Tag, Progress, Panel, Row, Col } from 'rsuite'
import { styled } from 'styled-components'

const _ = require('lodash')

const god_tooltip = <Tooltip><i>God</i></Tooltip>
const dragon_tooltip = <Tooltip><i>Dragon</i></Tooltip>
const tiger_tooltip = <Tooltip><i>Tiger</i></Tooltip>
const wolf_tooltip = (<Tooltip><i>Wolf</i></Tooltip>)

const threat_count = metrics => _.get(metrics, 'threat_count', 0)
const threats_disabled_count = metrics => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (JSON.stringify(key).match(/disabled/)) return sum + parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)

const threats_god_disabled_count = metrics => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (key.match(/god#disabled/)) return sum + parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)
const threats_dragon_disabled_count = metrics => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (key.match(/dragon#disabled/)) return sum + parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)
const threats_tiger_disabled_count = metrics => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (key.match(/tiger#disabled/)) return sum + parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)
const threats_wolf_disabled_count = metrics => Object.keys(_.get(metrics, 'threats_grouped_rank_status', {})).reduce(
  (sum, key) => {
    if (key.match(/wolf#disabled/)) return sum + parseFloat(_.get(metrics, ['threats_grouped_rank_status', `${key}`], 0) || 0)
    return sum
  }, 0
)

const threats_god_count = metrics => _.get(metrics, ['threats_grouped_rank', 'god'])
const threats_dragon_count = metrics => _.get(metrics, ['threats_grouped_rank', 'dragon'])
const threats_tiger_count = metrics => _.get(metrics, ['threats_grouped_rank', 'tiger'])
const threats_wolf_count = metrics => _.get(metrics, ['threats_grouped_rank', 'wolf'])

const threats_disabled_percent = metrics => (threats_disabled_count(metrics) / threat_count(metrics)) * 100
const threats_god_disabled_percent = metrics => (threats_god_disabled_count(metrics) / threats_god_count(metrics)) * 100
const threats_dragon_disabled_percent = metrics => (threats_dragon_disabled_count(metrics) / threats_dragon_count(metrics)) * 100
const threats_tiger_disabled_percent = metrics => (threats_tiger_disabled_count(metrics) / threats_tiger_count(metrics)) * 100
const threats_wolf_disabled_percent = metrics => (threats_wolf_disabled_count(metrics) / threats_wolf_count(metrics)) * 100

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
      <Panel header={`${threats_disabled_count(metrics)} Disabled`}>
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
