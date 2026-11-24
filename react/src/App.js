import { MantineProvider } from '@mantine/core'
import { HashRouter } from 'react-router-dom'
import NavBar from './navbar/NavBar.js'
import Routes from './Routes'
import { EventSourcePolyfill } from 'event-source-polyfill'
import ErrorBoundary from './ErrorBoundary'

global.EventSource = EventSourcePolyfill

const App = () => {
  return (
    <MantineProvider defaultColorScheme="dark">
      <HashRouter>
        <ErrorBoundary>
          <div style={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
            <header>
              <NavBar />
            </header>
            <main style={{ flex: 1 }}>
              <Routes />
            </main>
          </div>
        </ErrorBoundary>
      </HashRouter>
    </MantineProvider>
  );
}

export default App
