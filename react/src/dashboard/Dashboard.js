import { Row, Col, Grid, TagGroup } from 'rsuite'
import HeroesWorking from './HeroesWorking.js'
import ThreatsDisabled from './ThreatsDisabled.js'
import BattlesCharts from './BattlesCharts.js'
import HistoricalThreats from './HistoricalThreats.js'
import AverageTimeToMatch from './AverageTimeToMatch.js'
import AverageScore from './AverageScore.js'
import SuperHero from './SuperHero.js'


const Dashboard = () => {
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
