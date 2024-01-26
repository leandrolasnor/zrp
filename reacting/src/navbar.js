import { Navbar } from 'react-bootstrap'

const NavBar = () => {
  return(
    <Navbar variant='pills'>
      <Navbar.Brand href='#'>Dashboard</Navbar.Brand>
      <Navbar.Brand href='#heroes'>Heroes</Navbar.Brand>
    </Navbar>
  )
}

export default NavBar
