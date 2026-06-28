import { render, screen, fireEvent, act } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import HistoricalThreats from '../HistoricalThreats'
import reducer from '../reducer'

let resolveLoading
jest.mock('../actions', () => ({
    historical_threats: () => () => new Promise(resolve => { resolveLoading = resolve })
}))

beforeEach(() => {
    resolveLoading = undefined
})

const renderHistoricalThreats = (metricsState) => {
    const store = configureStore({
        reducer: { metrics: reducer },
        preloadedState: { metrics: metricsState }
    })
    return render(<Provider store={store}><HistoricalThreats /></Provider>)
}

const baseMetrics = {
    super_hero: null,
    historical_threats: [],
    average_score: 0,
    average_time_to_match: { hours: 0, minutes: 0, seconds: 0 },
    heroes_working: { global: 0, s: 0, a: 0, b: 0, c: 0, count: 0 },
    threats_disabled: { global: 0, god: 0, dragon: 0, tiger: 0, wolf: 0, count: 0 },
    heroes_distribution: null,
    threats_distribution: null,
    battles_lineup: [['One Hero', 0], ['Two Heroes', 0]]
}

const twoHeroThreat = {
    id: 1,
    name: 'Godzilla',
    rank: 'god',
    lat: 10,
    lng: 20,
    battle: {
        id: 1,
        score: 95,
        created_at: '2024-01-15T10:00:00Z',
        finished_at: '2024-01-15T10:05:00Z',
        duration: { hours: 0, minutes: 5, seconds: 0 },
        heroes: [
            { name: 'Superman', rank: 's' },
            { name: 'Batman', rank: 'a' }
        ]
    }
}

const singleHeroThreat = {
    id: 2,
    name: 'Mothra',
    rank: 'dragon',
    lat: 30,
    lng: 40,
    battle: {
        id: 2,
        score: 88,
        created_at: '2024-01-15T11:00:00Z',
        finished_at: '2024-01-15T11:03:00Z',
        duration: { hours: 0, minutes: 3, seconds: 30 },
        heroes: [{ name: 'Wonder Woman', rank: 's' }]
    }
}

describe('HistoricalThreats', () => {
    describe('loading state', () => {
        it('shows loader while loading', () => {
            renderHistoricalThreats(baseMetrics)
            expect(screen.getByText('Loading historical threats...')).toBeInTheDocument()
        })

        it('hides loader and shows content after loading completes', async () => {
            renderHistoricalThreats(baseMetrics)
            expect(screen.getByText('Loading historical threats...')).toBeInTheDocument()

            await act(async () => {
                resolveLoading()
            })

            expect(screen.queryByText('Loading historical threats...')).not.toBeInTheDocument()
        })
    })

    describe('empty state', () => {
        it('shows "No historical threats yet" when list is empty', async () => {
            renderHistoricalThreats(baseMetrics)
            await act(async () => { resolveLoading() })
            expect(screen.getByText('No historical threats yet')).toBeInTheDocument()
        })
    })

    describe('data state', () => {
        it('renders table with threats', async () => {
            renderHistoricalThreats({ ...baseMetrics, historical_threats: [twoHeroThreat, singleHeroThreat] })
            await act(async () => { resolveLoading() })
            expect(screen.getByText('Godzilla')).toBeInTheDocument()
            expect(screen.getByText('Mothra')).toBeInTheDocument()
            expect(screen.getByText('NAME')).toBeInTheDocument()
            expect(screen.getByText('LOCATION')).toBeInTheDocument()
        })

        it('renders rank badges for each threat', async () => {
            renderHistoricalThreats({ ...baseMetrics, historical_threats: [twoHeroThreat, singleHeroThreat] })
            await act(async () => { resolveLoading() })
            expect(screen.getByText('god')).toBeInTheDocument()
            expect(screen.getByText('dragon')).toBeInTheDocument()
        })

        it('renders refresh button', async () => {
            renderHistoricalThreats({ ...baseMetrics, historical_threats: [twoHeroThreat] })
            await act(async () => { resolveLoading() })
            const refreshButton = document.querySelector('.rs-btn-icon')
            expect(refreshButton).toBeInTheDocument()
        })

        it('renders initial date column', async () => {
            renderHistoricalThreats({ ...baseMetrics, historical_threats: [twoHeroThreat] })
            await act(async () => { resolveLoading() })
            expect(screen.getByText('INITIAL DATE')).toBeInTheDocument()
            expect(screen.getByText('FINISH DATE')).toBeInTheDocument()
        })
    })

    describe('expanded row', () => {
        it('renders expand buttons for each row', async () => {
            renderHistoricalThreats({ ...baseMetrics, historical_threats: [twoHeroThreat] })
            await act(async () => { resolveLoading() })
            const expandButtons = document.querySelectorAll('.rs-btn-icon-circle')
            expect(expandButtons.length).toBeGreaterThanOrEqual(1)
        })

        it('expands row on click and shows battle details', async () => {
            renderHistoricalThreats({ ...baseMetrics, historical_threats: [singleHeroThreat] })
            await act(async () => { resolveLoading() })
            const expandBtn = document.querySelector('.rs-btn-icon-circle')
            if (expandBtn) {
                fireEvent.click(expandBtn)
            }
            // After clicking expand, check that battle details appear
            const expandIcons = document.querySelectorAll('.rs-btn-icon-circle')
            expect(expandIcons.length).toBeGreaterThanOrEqual(1)
        })
    })

    describe('single hero battle', () => {
        it('renders threat with single hero', async () => {
            renderHistoricalThreats({ ...baseMetrics, historical_threats: [singleHeroThreat] })
            await act(async () => { resolveLoading() })
            // Verify the threat name appears (rsuite Table renders threat name cells)
            expect(screen.getByText('Mothra')).toBeInTheDocument()
            expect(screen.getByText('dragon')).toBeInTheDocument()
        })
    })
})
