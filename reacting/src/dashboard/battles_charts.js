import { Row, Col, Panel } from 'rsuite'
import { PieChart } from '@rsuite/charts'
import { useSelector } from 'react-redux'

const colors = ['#34c3ff', '#1464ac']
const BattlesCharts = props => {
  const { battles_lineup } = useSelector(state => state.metrics)

  return (
    <Panel bodyFill>
      <Row>
        <Col sm={24}>
          <PieChart data={battles_lineup} donut color={colors} />
        </Col>
      </Row>
    </Panel>
  )
}

export default BattlesCharts
