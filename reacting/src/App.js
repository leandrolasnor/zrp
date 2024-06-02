import { Container, Content, Header, CustomProvider } from 'rsuite'
import NavBar from './navbar.js'
import Routes from './routes'
import { ActionCableConsumer } from 'react-actioncable-provider'
import { EventSourcePolyfill } from 'event-source-polyfill'
import { useDispatch } from 'react-redux'

global.EventSource = EventSourcePolyfill

const App = () => {
  const dispatch = useDispatch()
  return (
    <CustomProvider theme="dark">
      <Container>
        <Header>
          <NavBar />
        </Header>
        <Content>
          <Routes />
          <ActionCableConsumer
            channel="NotificationChannel"
            onReceived={e => dispatch(e)}
            onConnected={e => console.log("Cable Online")}
            onDisconnected={e => console.log("Cable Offline")}
            onInitialized={e => console.log("Cable Initialized")}
            onRejected={e => console.log("Cable Rejected")}
          />
        </Content>
      </Container>
    </CustomProvider>
  );
}

export default App
