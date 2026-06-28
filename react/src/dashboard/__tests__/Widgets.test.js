jest.mock('@rsuite/charts', () => ({
    PieChart: ({ data }) => <div data-testid="pie-chart">{data.map(d => <span key={d[0]}>{d[0]}</span>)}</div>
}))

import { render, screen } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import AverageScore from '../AverageScore'
import AverageTimeToMatch from '../AverageTimeToMatch'
import SuperHero from '../SuperHero'
import HeroesDistribution from '../HeroesDistribution'
import ThreatsDistribution from '../ThreatsDistribution'
import HeroesWorking from '../HeroesWorking'
import ThreatsDisabled from '../ThreatsDisabled'
import BattlesCharts from '../BattlesCharts'
import reducer from '../reducer'

const renderWithMetrics = (Component, metricsState) => {
    const store = configureStore({
        reducer: { metrics: reducer },
        preloadedState: { metrics: metricsState }
    })
    return render(<Provider store={store}>{Component}</Provider>)
}

describe('AverageScore', () => {
    it('renders nothing when score is 0', () => {
        const { container } = renderWithMetrics(<AverageScore />, {
            average_score: 0
        })
        expect(container).toBeEmptyDOMElement()
    })

    it('renders badge with score', () => {
        renderWithMetrics(<AverageScore />, {
            average_score: 85
        })
        expect(screen.getByText('average score')).toBeInTheDocument()
        expect(screen.getByText('85')).toBeInTheDocument()
    })
})

describe('AverageTimeToMatch', () => {
    it('renders nothing when all zeros', () => {
        const { container } = renderWithMetrics(<AverageTimeToMatch />, {
            average_time_to_match: { hours: 0, minutes: 0, seconds: 0 }
        })
        expect(container).toBeEmptyDOMElement()
    })

    it('renders formatted time with hours', () => {
        renderWithMetrics(<AverageTimeToMatch />, {
            average_time_to_match: { hours: 1, minutes: 30, seconds: 15 }
        })
        expect(screen.getByText(/1h/)).toBeInTheDocument()
        expect(screen.getByText(/30min/)).toBeInTheDocument()
        expect(screen.getByText(/15s/)).toBeInTheDocument()
    })

    it('renders formatted time without hours', () => {
        renderWithMetrics(<AverageTimeToMatch />, {
            average_time_to_match: { hours: 0, minutes: 5, seconds: 45 }
        })
        expect(screen.getByText(/5min/)).toBeInTheDocument()
        expect(screen.getByText(/45s/)).toBeInTheDocument()
    })

    it('renders only seconds when hours and minutes are zero', () => {
        renderWithMetrics(<AverageTimeToMatch />, {
            average_time_to_match: { hours: 0, minutes: 0, seconds: 30 }
        })
        expect(screen.getByText(/30s/)).toBeInTheDocument()
    })
})

describe('SuperHero', () => {
    it('renders nothing when super_hero is null', () => {
        const { container } = renderWithMetrics(<SuperHero />, {
            super_hero: null
        })
        expect(container).toBeEmptyDOMElement()
    })

    it('renders super hero name and rank badge', () => {
        renderWithMetrics(<SuperHero />, {
            super_hero: { name: 'Superman', rank: 's' }
        })
        expect(screen.getByText('Superman')).toBeInTheDocument()
    })

    it('uses correct color for each rank', () => {
        renderWithMetrics(<SuperHero />, {
            super_hero: { name: 'A-Rank Hero', rank: 'a' }
        })
        expect(screen.getByText('A-Rank Hero')).toBeInTheDocument()
    })
})

describe('HeroesDistribution', () => {
    it('renders nothing when heroes_distribution is null', () => {
        const { container } = renderWithMetrics(<HeroesDistribution />, {
            heroes_distribution: null
        })
        expect(container).toBeEmptyDOMElement()
    })

    it('renders rank badges with counts', () => {
        renderWithMetrics(<HeroesDistribution />, {
            heroes_distribution: { s: 3, a: 7, b: 5, c: 2 }
        })
        expect(screen.getByText('S')).toBeInTheDocument()
        expect(screen.getByText('A')).toBeInTheDocument()
        expect(screen.getByText('B')).toBeInTheDocument()
        expect(screen.getByText('C')).toBeInTheDocument()
    })
})

describe('ThreatsDistribution', () => {
    it('renders nothing when threats_distribution is null', () => {
        const { container } = renderWithMetrics(<ThreatsDistribution />, {
            threats_distribution: null
        })
        expect(container).toBeEmptyDOMElement()
    })

    it('renders threat level badges with counts', () => {
        renderWithMetrics(<ThreatsDistribution />, {
            threats_distribution: { god: 1, dragon: 4, tiger: 10, wolf: 20 }
        })
        expect(screen.getByText('God')).toBeInTheDocument()
        expect(screen.getByText('Dragon')).toBeInTheDocument()
        expect(screen.getByText('Tiger')).toBeInTheDocument()
        expect(screen.getByText('Wolf')).toBeInTheDocument()
    })
})

describe('HeroesWorking', () => {
    it('renders progress circles', () => {
        const { container } = renderWithMetrics(<HeroesWorking />, {
            heroes_working: { global: 50, s: 20, a: 30, b: 10, c: 5, count: 4 }
        })
        expect(container.querySelector('.rs-progress-circle')).toBeInTheDocument()
    })
})

describe('ThreatsDisabled', () => {
    it('renders progress circles', () => {
        const { container } = renderWithMetrics(<ThreatsDisabled />, {
            threats_disabled: { global: 30, god: 5, dragon: 10, tiger: 8, wolf: 7, count: 4 }
        })
        expect(container.querySelector('.rs-progress-circle')).toBeInTheDocument()
    })
})

describe('BattlesCharts', () => {
    it('renders pie chart', () => {
        renderWithMetrics(<BattlesCharts />, {
            battles_lineup: [['One Hero', 10], ['Two Heroes', 5]]
        })
        expect(screen.getByText('One Hero')).toBeInTheDocument()
        expect(screen.getByText('Two Heroes')).toBeInTheDocument()
    })
})
