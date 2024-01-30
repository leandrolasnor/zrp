import { Container, CustomProvider } from 'rsuite'
import NavBar from './navbar.js'
import Routes from './routes'
import { EventSourcePolyfill } from 'event-source-polyfill'

global.EventSource = EventSourcePolyfill

const App = () => {
  return (
    <CustomProvider theme="dark">
      <Container>
        <NavBar />
        <Routes />
      </Container>
    </CustomProvider>
  );
}

export default App
