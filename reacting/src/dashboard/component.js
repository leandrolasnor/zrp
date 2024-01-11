import { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Row, Col } from 'react-bootstrap'
import { TagGroup, Tag, Progress } from 'rsuite'
import HeroesWorking from './heroes_working.js'
import ThreatsDisabled from './threats_disabled.js'
import BattlesCharts from './battles_charts.js'
import BattlesScatter from './battles_scatter_chart.js'

const _ = require('lodash')

const Dashboard = () => {
  const dispatch = useDispatch()
  const { user } = useSelector(state => state.auth)
  const { metrics } = useSelector(state => state.metrics)

  const [seconds, setSeconds] = useState(0)

  const average_time_to_match_hours = Number(_.get(metrics, ['average_time_to_match', 'hours'], 0)).toFixed(0)
  const average_time_to_match_minutes = Number(_.get(metrics, ['average_time_to_match', 'minutes'], 0)).toFixed(0)
  const average_time_to_match_seconds = Number(_.get(metrics, ['average_time_to_match', 'seconds'], 0)).toFixed(0)

  const sse = () => {
    setSeconds(0)
    let eventSource = new EventSource(
      `http://localhost:3000/v1/metrics/dashboard`,
      { headers: {'authorization': _.get(user, 'authorization')} }
    )
    eventSource.onmessage = (e) => dispatch(JSON.parse(e.data))
    eventSource.onerror = (e) => eventSource.close()
  }

  const initialized = useRef(false)
  useEffect(() => {
    if (!initialized.current) {
      initialized.current = true
      sse()
      setInterval(() => {
        setSeconds(prev => prev+12)
      },1000)
      setInterval(sse, 10000)
    }
  }, [])

  return(
    <Row>
      <Row>
        <Progress.Line status="success" strokeWidth={1} percent={seconds} showInfo={false} />
        <Col sm={12}>
          <TagGroup>
            <Tag color="blue" size="sm">average score :: {`${Number(_.get(metrics, 'average_score', 0)).toFixed(2)}`}</Tag>
            <Tag color="green" size="sm">
              average time to match :: {
                `${average_time_to_match_hours > 0 ? `${average_time_to_match_hours} hours` : ``}
                ${average_time_to_match_minutes > 0 ? `${average_time_to_match_minutes} minutes` : ``}
                ${average_time_to_match_seconds > 0 ? `${average_time_to_match_seconds} seconds` : ``}`
              }
            </Tag>
          </TagGroup>
        </Col>
      </Row>
      <Row className='mt-2'>
        <Col sm={4}>
          <HeroesWorking metrics={metrics} />
        </Col>
        <Col sm={4}>
          <ThreatsDisabled metrics={metrics} />
        </Col>
        <Col sm={4}>
          <BattlesCharts metrics={metrics} />
        </Col>
      </Row>
    </Row>
  )
}

export default Dashboard
