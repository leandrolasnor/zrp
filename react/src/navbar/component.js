import { Navbar, Nav, Slider } from 'rsuite'
import InsurgencySlider from './insurgency_slider'

const NavBar = () => {
  return (
    <Navbar variant='pills'>
      <Navbar.Brand href="https://zrp.github.io/challenges/dev/" target='_blank'>Description</Navbar.Brand>
      <Nav>
        <Nav.Item href='/#'>Dashboard</Nav.Item>
        <Nav.Item href='#heroes'>Heroes</Nav.Item>
      </Nav>
      <Nav pullRight>
        <Nav.Item>
          <InsurgencySlider />
        </Nav.Item>
      </Nav>
    </Navbar>
  )
}

export default NavBar
