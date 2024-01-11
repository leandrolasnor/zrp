import React from 'react'
import { Row, Col, Card } from 'react-bootstrap'
import { PieChart } from '@rsuite/charts'

const _ = require('lodash')

const colors = ['#34c3ff', '#1464ac']

const BattlesCharts = props => {
  const { metrics } = props

  return(
    <Card>
      <Card.Body>
        <Card.Title>Battles</Card.Title>
        <Card.Subtitle className="mb-0 text-muted">{`${_.get(metrics, 'battle_count', 0)} Altogether`}</Card.Subtitle>
        <Row>
          <Col sm={12}>
            <PieChart height={162} className='mt-0' data={_.get(metrics, 'battles_two_and_one_percent', [])} donut color={colors} />
          </Col>
        </Row>
      </Card.Body>
    </Card>
  )
}

export default BattlesCharts
