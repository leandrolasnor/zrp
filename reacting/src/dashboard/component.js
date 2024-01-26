import { useEffect, useState } from 'react'
import { useSelector, useDispatch } from 'react-redux'
import { Row, Col } from 'react-bootstrap'
import { TagGroup, Progress } from 'rsuite'
import HeroesWorking from './heroes_working.js'
import ThreatsDisabled from './threats_disabled.js'
import BattlesCharts from './battles_charts.js'
import HistoricalThreats from './historical_threats.js'
import AverageTimeToMatch from './average_time_to_match.js'
import AverageScore from './average_score.js'
import SuperHero from './super_hero.js'
import { get_metrics } from './actions.js'

const _ = require('lodash')

const Dashboard = () => {
  const dispatch = useDispatch()
  const [counter, setCounter] = useState(0)
  const { metrics } = useSelector(state => state.metrics)
  const average_score = _.get(metrics, 'average_score', 0)
  const average_time_to_match = _.get(metrics, 'average_time_to_match', 0)
  const super_hero = _.get(metrics, 'super_hero', 0)

  useEffect(() => {
    dispatch(get_metrics())
    const counter_interval = setInterval(() => setCounter(prev => prev + 10), 1000)
    const metrics_interval = setInterval(() => { setCounter(0); dispatch(get_metrics()) }, 11000)
    return () => {
      clearInterval(counter_interval)
      clearInterval(metrics_interval)
    }
  }, [])

  return (
    <Row>
      <Row>
        <Progress.Line status="success" strokeWidth={1} percent={counter} showInfo={false} />
        <Col sm={12}>
          <TagGroup>
            <AverageScore score={average_score}></AverageScore>
            <AverageTimeToMatch data={average_time_to_match} />
            <SuperHero hero={super_hero} />
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
