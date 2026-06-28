import { render, screen } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import InsurgencySlider from '../InsurgencySlider'

jest.mock('../../dashboard/actions', () => ({
    set_insurgency: jest.fn(() => () => { })
}))

const renderSlider = () => {
    const store = configureStore({ reducer: { metrics: () => ({}) } })
    return render(<Provider store={store}><InsurgencySlider /></Provider>)
}

describe('InsurgencySlider', () => {
    it('renders slider with marks', () => {
        renderSlider()
        expect(screen.getByText('5s')).toBeInTheDocument()
        expect(screen.getByText('10s')).toBeInTheDocument()
        expect(screen.getByText('20s')).toBeInTheDocument()
    })

    it('renders slider input', () => {
        renderSlider()
        const slider = document.querySelector('.rs-slider')
        expect(slider).toBeInTheDocument()
    })
})
