import { Tooltip, Whisper, Progress, Panel, Row, Col } from 'rsuite'
import { useSelector } from 'react-redux'
import ThreatsDistribution from './threats_distribution'

const _ = require('lodash')

const ThreatsDisabled = () => {
  const { threats_disabled } = useSelector(state => state.metrics)

  return (
    <Panel bodyFill>
      <Row>
        <Col className="ms-4" sm={8}>
          <Progress.Circle percent={_.get(threats_disabled, 'global', 0)} strokeColor="#ffdb58" />
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={<Tooltip><i>God</i></Tooltip>}>
            <Progress.Circle percent={_.get(threats_disabled, 'god', 0)} status="active" strokeColor="#2986cc" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={<Tooltip><i>Dragon</i></Tooltip>}>
            <Progress.Circle percent={_.get(threats_disabled, 'dragon', 0)} status="active" strokeColor="#0AB653" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={<Tooltip><i>Tiger</i></Tooltip>}>
            <Progress.Circle percent={_.get(threats_disabled, 'tiger', 0)} status="active" strokeColor="#a442f5" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={<Tooltip><i>Wolf</i></Tooltip>}>
            <Progress.Circle percent={_.get(threats_disabled, 'wolf', 0)} status="active" strokeColor="#ff0000" />
          </Whisper>
        </Col>
      </Row>
      <Panel header={`${_.get(threats_disabled, 'count', 0) } Disabled`}>
        <ThreatsDistribution />
      </Panel>
    </Panel>
  )
}

export default ThreatsDisabled
