import { Container, Content, Header, CustomProvider } from 'rsuite'
import NavBar from './navbar/NavBar.js'
import Routes from './Routes'
import { ActionCableConsumer } from 'react-actioncable-provider'
import { EventSourcePolyfill } from 'event-source-polyfill'
import { useDispatch } from 'react-redux'
import WS_ACTION_TYPES from './ws_action_types'
import ErrorBoundary from './ErrorBoundary'

global.EventSource = EventSourcePolyfill

const App = () => {
  const dispatch = useDispatch()

  const handleReceived = (msg) => {
    if (!msg || typeof msg !== 'object' || !msg.type) {
      console.warn('WebSocket: invalid message discarded', msg)
      return
    }
    if (!WS_ACTION_TYPES.has(msg.type)) {
      console.warn(`WebSocket: action type "${msg.type}" not in whitelist, discarded`)
      return
    }
    dispatch({ type: msg.type, payload: msg.payload })
  }

  return (
    <CustomProvider theme="dark">
      <ErrorBoundary>
        <Container>
          <Header>
            <NavBar />
          </Header>
          <Content>
            <Routes />
            <ActionCableConsumer
              channel="NotificationChannel"
              onReceived={handleReceived}
              onConnected={e => process.env.NODE_ENV === 'development' && console.log("Cable Online")}
              onDisconnected={e => process.env.NODE_ENV === 'development' && console.log("Cable Offline")}
              onInitialized={e => process.env.NODE_ENV === 'development' && console.log("Cable Initialized")}
              onRejected={e => process.env.NODE_ENV === 'development' && console.log("Cable Rejected")}
            />
          </Content>
        </Container>
      </ErrorBoundary>
    </CustomProvider>
  );
}

export default App
