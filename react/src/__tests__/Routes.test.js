import { render, screen } from '@testing-library/react'
import Routes from '../Routes'

jest.mock('../dashboard/Dashboard', () => () => <div data-testid="dashboard">Dashboard</div>)
jest.mock('../heroes/Heroes', () => () => <div data-testid="heroes">Heroes</div>)

describe('Routes', () => {
    it('renders dashboard route by default', () => {
        render(<Routes />)
        expect(screen.getByTestId('dashboard')).toBeInTheDocument()
    })

    it('renders heroes route when hash is #/heroes', () => {
        window.location.hash = '#/heroes'
        render(<Routes />)
        expect(screen.getByTestId('heroes')).toBeInTheDocument()
        window.location.hash = ''
    })
})
