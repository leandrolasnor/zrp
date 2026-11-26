import { render, screen } from '@testing-library/react'
import { MantineProvider } from '@mantine/core'
import { MemoryRouter } from 'react-router-dom'
import NavBar from '../NavBar'

jest.mock('../InsurgencySlider', () => () => <div data-testid="insurgency-slider">InsurgencySlider</div>)

const renderNavBar = () => render(
    <MantineProvider>
        <MemoryRouter>
            <NavBar />
        </MemoryRouter>
    </MantineProvider>
)

describe('NavBar', () => {
    it('renders brand link', () => {
        renderNavBar()
        const brand = screen.getByText('Description')
        expect(brand).toBeInTheDocument()
        expect(brand.closest('a')).toHaveAttribute('href', 'https://zrp.github.io/challenges/dev/')
    })

    it('renders nav items', () => {
        renderNavBar()
        expect(screen.getByText('Dashboard')).toBeInTheDocument()
        expect(screen.getByText('Heroes')).toBeInTheDocument()
    })

    it('renders insurgency slider', () => {
        renderNavBar()
        expect(screen.getByTestId('insurgency-slider')).toBeInTheDocument()
    })
})
