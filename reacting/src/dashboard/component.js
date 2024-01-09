import { useEffect, useRef } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import HeroesWorkingCount from './heroes_working_count.js'
import { Row, Col } from 'react-bootstrap'

const _ = require('lodash')

const Dashboard = () => {
  const dispatch = useDispatch()
  const { user } = useSelector(state => state.auth)
  const { metrics } = useSelector(state => state.metrics)

  const initialized = useRef(false)

  useEffect(() => {
    if (!initialized.current) {
      initialized.current = true
      let eventSource = new EventSource(
        `http://localhost:3000/v1/metrics/dashboard`,
        { headers: {'authorization': _.get(user, 'authorization')} }
      )
      eventSource.onmessage = (e) => dispatch(JSON.parse(e.data))
      eventSource.onerror = (e) => eventSource.close()
    }
  }, [dispatch, user, metrics])

  return(
    <Row>
      <Col sm={4}>
        <HeroesWorkingCount />
      </Col>
    </Row>
  )
}

export default Dashboard
