import { render, screen } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import Dashboard from '../Dashboard'
import reducer from '../reducer'

jest.mock('../HeroesWorking', () => () => <div data-testid="heroes-working">HeroesWorking</div>)
jest.mock('../ThreatsDisabled', () => () => <div data-testid="threats-disabled">ThreatsDisabled</div>)
jest.mock('../BattlesCharts', () => () => <div data-testid="battles-charts">BattlesCharts</div>)
jest.mock('../HistoricalThreats', () => () => <div data-testid="historical-threats">HistoricalThreats</div>)
jest.mock('../AverageTimeToMatch', () => () => <div data-testid="avg-time">AverageTimeToMatch</div>)
jest.mock('../AverageScore', () => () => <div data-testid="avg-score">AverageScore</div>)
jest.mock('../SuperHero', () => () => <div data-testid="super-hero">SuperHero</div>)

const renderDashboard = () => {
    const store = configureStore({ reducer: { metrics: reducer } })
    return render(<Provider store={store}><Dashboard /></Provider>)
}

describe('Dashboard', () => {
    it('renders all dashboard widgets', () => {
        renderDashboard()
        expect(screen.getByTestId('heroes-working')).toBeInTheDocument()
        expect(screen.getByTestId('threats-disabled')).toBeInTheDocument()
        expect(screen.getByTestId('battles-charts')).toBeInTheDocument()
        expect(screen.getByTestId('historical-threats')).toBeInTheDocument()
        expect(screen.getByTestId('avg-time')).toBeInTheDocument()
        expect(screen.getByTestId('avg-score')).toBeInTheDocument()
        expect(screen.getByTestId('super-hero')).toBeInTheDocument()
    })
})
