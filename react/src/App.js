import { Container, Content, Header, CustomProvider } from 'rsuite'
import NavBar from './navbar/NavBar.js'
import Routes from './Routes'
import { EventSourcePolyfill } from 'event-source-polyfill'
import ErrorBoundary from './ErrorBoundary'

global.EventSource = EventSourcePolyfill

const App = () => {
  return (
    <CustomProvider theme="dark">
      <ErrorBoundary>
        <Container>
          <Header>
            <NavBar />
          </Header>
          <Content>
            <Routes />
          </Content>
        </Container>
      </ErrorBoundary>
    </CustomProvider>
  );
}

export default App
