import { render, screen } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import App from '../App'
import reducer from '../heroes/reducer'

jest.mock('../navbar/component.js', () => () => <div data-testid="navbar">NavBar</div>)
jest.mock('../routes', () => () => <div data-testid="routes">Routes</div>)
jest.mock('react-actioncable-provider', () => ({
  ActionCableConsumer: ({ onReceived }) => <div data-testid="action-cable" />
}))
jest.mock('event-source-polyfill', () => ({ EventSourcePolyfill: class {} }))
jest.mock('../ws_action_types', () => ({ default: new Set(), has: () => false }))

const renderApp = () => {
  const store = configureStore({ reducer: { heroes: reducer } })
  return render(<Provider store={store}><App /></Provider>)
}

describe('App', () => {
  it('renders navbar and routes', () => {
    renderApp()
    expect(screen.getByTestId('navbar')).toBeInTheDocument()
    expect(screen.getByTestId('routes')).toBeInTheDocument()
  })

  it('renders ActionCable consumer', () => {
    renderApp()
    expect(screen.getByTestId('action-cable')).toBeInTheDocument()
  })
})
