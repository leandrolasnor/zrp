import { Container, Row } from 'react-bootstrap'
import NavBar from './navbar.js'
import Routes from './routes'
import { EventSourcePolyfill } from 'event-source-polyfill'

global.EventSource = EventSourcePolyfill

const App = () => {
  return (
    <Container>
      <Row><NavBar /></Row>
      <Row><Routes /></Row>
    </Container>
  );
}

export default App
