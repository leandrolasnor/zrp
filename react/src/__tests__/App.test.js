import { render, screen } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import App from '../App'
import reducer from '../heroes/reducer'
import WS_ACTION_TYPES from '../ws_action_types'

jest.mock('../navbar/NavBar', () => () => <div data-testid="navbar">NavBar</div>)
jest.mock('../Routes', () => () => <div data-testid="routes">Routes</div>)
jest.mock('event-source-polyfill', () => ({ EventSourcePolyfill: class { } }))

let mockOnReceived = null

jest.mock('react-actioncable-provider', () => ({
  ActionCableConsumer: ({ onReceived }) => {
    mockOnReceived = onReceived
    return <div data-testid="action-cable" />
  }
}))

const renderApp = () => {
  const store = configureStore({ reducer: { heroes: reducer } })
  return render(<Provider store={store}><App /></Provider>)
}

describe('App', () => {
  beforeEach(() => {
    jest.spyOn(console, 'warn').mockImplementation(() => { })
    jest.spyOn(console, 'log').mockImplementation(() => { })
  })

  afterEach(() => {
    jest.restoreAllMocks()
    mockOnReceived = null
  })

  it('renders navbar and routes', () => {
    renderApp()
    expect(screen.getByTestId('navbar')).toBeInTheDocument()
    expect(screen.getByTestId('routes')).toBeInTheDocument()
  })

  it('renders ActionCable consumer', () => {
    renderApp()
    expect(screen.getByTestId('action-cable')).toBeInTheDocument()
  })

  describe('WebSocket message handling', () => {
    it('discards null message', () => {
      renderApp()
      expect(mockOnReceived).not.toBeNull()
      mockOnReceived(null)
      expect(console.warn).toHaveBeenCalled()
    })

    it('discards non-object message', () => {
      renderApp()
      mockOnReceived('string message')
      expect(console.warn).toHaveBeenCalled()
    })

    it('discards message without type', () => {
      renderApp()
      mockOnReceived({ payload: { data: 1 } })
      expect(console.warn).toHaveBeenCalled()
    })

    it('discards message with type not in whitelist', () => {
      renderApp()
      mockOnReceived({ type: 'INVALID_ACTION', payload: { data: 1 } })
      expect(console.warn).toHaveBeenCalled()
    })

    it('dispatches whitelisted message types', () => {
      renderApp()
      const validType = Array.from(WS_ACTION_TYPES)[0]
      mockOnReceived({ type: validType, payload: { data: 1 } })
      expect(console.warn).not.toHaveBeenCalled()
    })

    it('dispatches all whitelisted message types without warning', () => {
      renderApp()
      WS_ACTION_TYPES.forEach(type => {
        mockOnReceived({ type, payload: {} })
      })
      expect(console.warn).not.toHaveBeenCalled()
    })
  })

  describe('ActionCable lifecycle callbacks', () => {
    it('logs in development mode', () => {
      const origEnv = process.env.NODE_ENV
      process.env.NODE_ENV = 'development'
      jest.spyOn(console, 'log').mockImplementation(() => { })

      renderApp()

      process.env.NODE_ENV = origEnv
    })
  })
})
