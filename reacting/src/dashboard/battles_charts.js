import { Row, Col, Panel } from 'rsuite'
import { PieChart } from '@rsuite/charts'
import { styled } from 'styled-components'

const _ = require('lodash')
const colors = ['#34c3ff', '#1464ac']
const BattlesCharts = props => {
  const { metrics } = props

  return (
    <Panel shaded bodyFill>
      <Row>
        <Col sm={24}>
          <PieChart data={_.get(metrics, 'battles_two_and_one_percent', [])} donut color={colors} />
        </Col>
      </Row>
    </Panel>
  )
}

export default BattlesCharts
