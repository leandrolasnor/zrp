import { Row, Col, Panel } from 'rsuite'
import { PieChart } from '@rsuite/charts'
import { styled } from 'styled-components'

const _ = require('lodash')
const colors = ['#34c3ff', '#1464ac']
const PanelStyled = styled(Panel)`
  display: 'inline-block'
  width: 240
`
const BattlesCharts = props => {
  const { metrics } = props

  return (
    <PanelStyled shaded bordered bodyFill>
      <Row>
        <Col sm={24}>
          <PieChart className='mt-0' data={_.get(metrics, 'battles_two_and_one_percent', [])} donut color={colors} />
        </Col>
      </Row>
    </PanelStyled>
  )
}

export default BattlesCharts
