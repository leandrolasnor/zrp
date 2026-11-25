import { Container, Group, SimpleGrid, Stack } from '@mantine/core'
import HeroesWorking from './HeroesWorking.js'
import ThreatsDisabled from './ThreatsDisabled.js'
import BattlesCharts from './BattlesCharts.js'
import HistoricalThreats from './HistoricalThreats.js'
import AverageTimeToMatch from './AverageTimeToMatch.js'
import AverageScore from './AverageScore.js'
import SuperHero from './SuperHero.js'
import { useDispatch } from 'react-redux'
import { useEffect } from 'react'
import { connect_widgets_stream, disconnect_widgets_stream } from './actions'


const Dashboard = () => {
  const dispatch = useDispatch()

  useEffect(() => {
    dispatch(connect_widgets_stream())
    return () => dispatch(disconnect_widgets_stream())
  }, [dispatch])

  return (
    <Container fluid mt="md">
      <Stack gap="md">
        <Group gap="xs" align="center">
          <AverageScore />
          <AverageTimeToMatch />
          <SuperHero />
        </Group>
        <SimpleGrid cols={{ base: 1, sm: 3 }} spacing="md">
          <HeroesWorking />
          <ThreatsDisabled />
          <BattlesCharts />
        </SimpleGrid>
        <HistoricalThreats />
      </Stack>
    </Container>
  )
}

export default Dashboard
