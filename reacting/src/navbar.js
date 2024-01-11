import { useDispatch } from 'react-redux'
import { Nav, Navbar, Button } from 'react-bootstrap'
import { logout } from './auth/actions'

const NavBar = () => {
  const dispatch = useDispatch()
  return(
    <Navbar variant='pills'>
      <Navbar.Brand href='#'>Dashboard</Navbar.Brand>
      <Navbar.Collapse className='justify-content-end'>
        <Nav.Item>
          <Button variant='link' href='#' onClick={() => dispatch(logout())}>Sign out</Button>
        </Nav.Item>
      </Navbar.Collapse>
    </Navbar>
  )
}

export default NavBar
