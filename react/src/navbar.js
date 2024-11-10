import { Navbar, Nav } from 'rsuite'

const NavBar = () => {
  return (
    <Navbar variant='pills'>
      <Navbar.Brand href="https://zrp.github.io/challenges/dev/" target='_blank'>Description</Navbar.Brand>
      <Nav>
        <Nav.Item href='/#'>Dashboard</Nav.Item>
        <Nav.Item href='#heroes'>Heroes</Nav.Item>
      </Nav>
    </Navbar>
  )
}

export default NavBar
