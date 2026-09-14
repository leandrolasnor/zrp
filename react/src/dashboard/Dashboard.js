import { Row, Col, Grid, TagGroup } from 'rsuite'
import HeroesWorking from './HeroesWorking.js'
import ThreatsDisabled from './ThreatsDisabled.js'
import BattlesCharts from './BattlesCharts.js'
import HistoricalThreats from './HistoricalThreats.js'
import AverageTimeToMatch from './AverageTimeToMatch.js'
import AverageScore from './AverageScore.js'
import SuperHero from './SuperHero.js'
import { useDispatch } from 'react-redux'
import { useRef, useCallback, useEffect } from 'react'
import ACTION_TYPES from './action_types'


const Dashboard = () => {
  const dispatch = useDispatch()
  const eventSourceRef = useRef(null)
  const reconnectTimeoutRef = useRef(null)

  const handleReceived = useCallback((type, payload) => {
    if (!ACTION_TYPES.has(type)) {
      console.warn(`SSE: action type "${type}" not in whitelist, discarded`)
      return
    }
    dispatch({ type, payload })
  }, [dispatch])

  const widgets = useCallback(() => {
    if (eventSourceRef.current) eventSourceRef.current.close()
    const eventSource = new EventSource(`${process.env.REACT_APP_API_URL || ''}/v1/sse/widgets`)
    eventSourceRef.current = eventSource

    ACTION_TYPES.forEach((eventType) => {
      eventSource.addEventListener(eventType, (event) => {
        try {
          const payload = JSON.parse(event.data)
          handleReceived(eventType, payload)
        } catch (error) {
          console.error('SSE: Error parsing message', error)
        }
      })
    })

    eventSource.onopen = () => {
      if (process.env.NODE_ENV === 'development') {
        console.log('SSE: Connected')
      }
    }

    eventSource.onerror = (error) => {
      if (process.env.NODE_ENV === 'development') {
        console.log('SSE: Disconnected', error)
      }

      eventSource.close()
      if (reconnectTimeoutRef.current) {
        clearTimeout(reconnectTimeoutRef.current)
      }
      reconnectTimeoutRef.current = setTimeout(() => {
        if (process.env.NODE_ENV === 'development') {
          console.log('SSE: Attempting to reconnect...')
        }
        widgets()
      }, 5000)
    }
  }, [handleReceived])

  useEffect(() => {
    widgets()

    return () => {
      if (reconnectTimeoutRef.current) {
        clearTimeout(reconnectTimeoutRef.current)
      }
      if (eventSourceRef.current) {
        eventSourceRef.current.close()
      }
    }
  }, [widgets])

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
