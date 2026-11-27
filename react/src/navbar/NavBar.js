import { Group, Anchor } from '@mantine/core'
import { useLocation, Link } from 'react-router-dom'
import InsurgencySlider from './InsurgencySlider'

const NavBar = () => {
  const location = useLocation()
  const isDashboard = location.pathname === '/'
  const isHeroes = location.pathname === '/heroes'

  return (
    <Group justify="space-between" p="sm" style={{ width: '100%' }}>
      <Group>
        <Anchor href="https://zrp.github.io/challenges/dev/" target="_blank" fw={700} c="white">Description</Anchor>
        <Anchor component={Link} to="/" underline="hover" fw={isDashboard ? 700 : 400} c={isDashboard ? 'blue' : 'white'}>Dashboard</Anchor>
        <Anchor component={Link} to="/heroes" underline="hover" fw={isHeroes ? 700 : 400} c={isHeroes ? 'blue' : 'white'}>Heroes</Anchor>
      </Group>
      <Group>
        <InsurgencySlider />
      </Group>
    </Group>
  )
}

export default NavBar
