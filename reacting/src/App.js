import { Container, Content, Header, CustomProvider } from 'rsuite'
import NavBar from './navbar.js'
import Routes from './routes'
import { ActionCableConsumer } from 'react-actioncable-provider'
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
          <ActionCableConsumer
            channel="NotificationChannel"
            onReceived={props => console.log(props)}
            onConnected={props => console.log("Cable Online")}
            onDisconnected={props => console.log("Cable Offline")}
            onInitialized={props => console.log("Cable Initialized")}
            onRejected={props => console.log("Cable Rejected")}
          />
        </Content>
      </Container>
    </CustomProvider>
  );
}

export default App
