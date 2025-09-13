import { useDispatch } from 'react-redux'
import { Row, Col, Grid } from 'rsuite'
import { TagGroup } from 'rsuite'
import HeroesWorking from './heroes_working.js'
import ThreatsDisabled from './threats_disabled.js'
import BattlesCharts from './battles_charts.js'
import HistoricalThreats from './historical_threats.js'
import AverageTimeToMatch from './average_time_to_match.js'
import AverageScore from './average_score.js'
import SuperHero from './super_hero.js'
import { useEffect } from 'react'


const Dashboard = () => {
  const dispatch = useDispatch()

  return (
    <Grid fluid>
      <Row className='mt-3'>
        <Col>
          <TagGroup>
            <AverageScore />
            <AverageTimeToMatch />
            <SuperHero />
          </TagGroup>
        </Col>
      </Row>
      <Row className='mt-3'>
        <Col sm={8}>
          <HeroesWorking />
        </Col>
        <Col sm={8}>
          <ThreatsDisabled />
        </Col>
        <Col sm={8}>
          <BattlesCharts />
        </Col>
      </Row>
      <Row className='mt-1'>
        <HistoricalThreats />
      </Row>
    </Grid>
  )
}

export default Dashboard
