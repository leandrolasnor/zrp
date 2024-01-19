import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Row, Col } from 'react-bootstrap'
import { TagGroup, Tag, Progress } from 'rsuite'
import HeroesWorking from './heroes_working.js'
import ThreatsDisabled from './threats_disabled.js'
import BattlesCharts from './battles_charts.js'
import HistoricalThreats from './historical_threats.js'
import AverageTimeToMatch from './average_time_to_match.js'
import AverageScore from './average_score.js'
import SuperHero from './super_hero.js'

const _ = require('lodash')

const Dashboard = () => {
  const dispatch = useDispatch()
  const [counter, setCounter] = useState(0)
  const { user } = useSelector(state => state.auth)
  const { metrics } = useSelector(state => state.metrics)

  const sse = () => {
    setCounter(0)
    let eventSource = new EventSource(
      `http://localhost:3000/v1/metrics/dashboard`,
      { headers: { 'authorization': _.get(user, 'authorization') } }
    )
    eventSource.onmessage = (e) => dispatch(JSON.parse(e.data))
    eventSource.onerror = (e) => eventSource.close()
  }

  useEffect(() => {
    sse()
    const counter_interval = setInterval(() => {
      setCounter(prev => prev + 10)
    }, 1000)
    const request_sse = setInterval(sse, 11000)
    return () => {
      clearInterval(counter_interval)
      clearInterval(request_sse)
    }
  }, [])

  return (
    <Row>
      <Row>
        <Progress.Line status="success" strokeWidth={1} percent={counter} showInfo={false} />
        <Col sm={12}>
          <TagGroup>
            <AverageScore score={_.get(metrics, 'average_score', 0)}></AverageScore>
            <AverageTimeToMatch data={_.get(metrics, 'average_time_to_match', {})} />
            <SuperHero hero={_.get(metrics, 'super_hero', '')} />
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
      <Row className='mt-4'>
        <Col>
          <HistoricalThreats />
        </Col>
      </Row>
    </Row>
  )
}

export default Dashboard
