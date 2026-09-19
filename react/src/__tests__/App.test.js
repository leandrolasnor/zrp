import { render, screen } from '@testing-library/react'
import App from '../App'

jest.mock('../navbar/NavBar', () => () => <div data-testid="navbar">NavBar</div>)
jest.mock('../Routes', () => () => <div data-testid="routes">Routes</div>)
jest.mock('event-source-polyfill', () => ({ EventSourcePolyfill: class { } }))

const renderApp = () => render(<App />)

describe('App', () => {
  it('renders navbar', () => {
    renderApp()
    expect(screen.getByTestId('navbar')).toBeInTheDocument()
  })

  it('renders routes', () => {
    renderApp()
    expect(screen.getByTestId('routes')).toBeInTheDocument()
  })

  it('is wrapped in an ErrorBoundary', () => {
    renderApp()
    expect(screen.getByTestId('navbar')).toBeInTheDocument()
    expect(screen.getByTestId('routes')).toBeInTheDocument()
  })
})