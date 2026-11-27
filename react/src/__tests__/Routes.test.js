import { render, screen } from '@testing-library/react'
import { HashRouter } from 'react-router-dom'
import Routes from '../Routes'

jest.mock('../dashboard/Dashboard', () => () => <div data-testid="dashboard">Dashboard</div>)
jest.mock('../heroes/Heroes', () => () => <div data-testid="heroes">Heroes</div>)

const renderRoutes = () => render(
    <HashRouter future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
        <Routes />
    </HashRouter>
)

describe('Routes', () => {
    afterEach(() => {
        window.location.hash = ''
    })

    it('renders dashboard route by default', () => {
        renderRoutes()
        expect(screen.getByTestId('dashboard')).toBeInTheDocument()
    })

    it('renders heroes route when hash is #/heroes', () => {
        window.location.hash = '#/heroes'
        renderRoutes()
        expect(screen.getByTestId('heroes')).toBeInTheDocument()
    })
})
