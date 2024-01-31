import { Container, Content, Header, CustomProvider } from 'rsuite'
import NavBar from './navbar.js'
import Routes from './routes'
import { EventSourcePolyfill } from 'event-source-polyfill'

global.EventSource = EventSourcePolyfill

const App = () => {
  return (
    <CustomProvider theme="dark">
      <Container>
        <Header>
          <NavBar />
        </Header>
        <Content>
          <Routes />
        </Content>
      </Container>
    </CustomProvider>
  );
}

export default App
