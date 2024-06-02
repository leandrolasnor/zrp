import { Row, Col, Panel, Tooltip } from 'rsuite'
import { Whisper, Progress } from 'rsuite'
import { useSelector } from 'react-redux'

const _ = require('lodash')

const HeroesWorking = props => {
  const { heroes_working } = useSelector(state => state.metrics)

  return (
    <Panel bodyFill>
      <Row>
        <Col className='mt-3 ms-4' sm={8}>
          <Progress.Circle percent={_.get(heroes_working,'global', 0)} strokeColor="#ffdb58" />
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={<Tooltip><i>S</i></Tooltip>}>
            <Progress.Circle percent={_.get(heroes_working, 's', 0)} status="active" strokeColor="#2986cc" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={<Tooltip><i>A</i></Tooltip>}>
            <Progress.Circle percent={_.get(heroes_working, 'a', 0)} status="active" strokeColor="#0AB653" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={<Tooltip><i>B</i></Tooltip>}>
            <Progress.Circle percent={_.get(heroes_working, 'b', 0)} status="active" strokeColor="#a442f5" />
          </Whisper>
        </Col>
        <Col className='mt-5' sm={3}>
          <Whisper placement="bottom" controlId="control-id-hover" trigger="hover" speaker={<Tooltip><i>C</i></Tooltip>}>
            <Progress.Circle percent={_.get(heroes_working, 'c', 0)} status="active" strokeColor="#ff0000" />
          </Whisper>
        </Col>
      </Row>
      <Panel header={`${_.get(heroes_working, 'count', 0) } Working`}>
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
