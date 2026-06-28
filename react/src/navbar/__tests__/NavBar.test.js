import { render, screen } from '@testing-library/react'
import NavBar from '../NavBar'

jest.mock('../InsurgencySlider', () => () => <div data-testid="insurgency-slider">InsurgencySlider</div>)

describe('NavBar', () => {
    it('renders brand link', () => {
        render(<NavBar />)
        const brand = screen.getByText('Description')
        expect(brand).toBeInTheDocument()
        expect(brand.closest('a')).toHaveAttribute('href', 'https://zrp.github.io/challenges/dev/')
    })

    it('renders nav items', () => {
        render(<NavBar />)
        expect(screen.getByText('Dashboard')).toBeInTheDocument()
        expect(screen.getByText('Heroes')).toBeInTheDocument()
    })

    it('renders insurgency slider', () => {
        render(<NavBar />)
        expect(screen.getByTestId('insurgency-slider')).toBeInTheDocument()
    })
})
