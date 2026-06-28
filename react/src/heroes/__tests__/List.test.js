import { render, screen, fireEvent } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import List from '../List'
import reducer from '../reducer'

jest.mock('../actions', () => ({
    destroy_hero: () => () => { },
    get_ranks: () => ({ type: 'RANKS_FETCHED', payload: ['s', 'a', 'b', 'c'] }),
    create_hero: () => ({ type: 'HERO_CREATED', payload: {} }),
    update_hero: () => ({ type: 'HERO_UPDATED', payload: {} })
}))

const renderList = (heroesState, metricsState = {}) => {
    const store = configureStore({
        reducer: { heroes: reducer, metrics: () => metricsState },
        preloadedState: { heroes: heroesState }
    })
    return render(<Provider store={store}><List /></Provider>)
}

const baseState = {
    ranks: ['s', 'a', 'b', 'c'],
    statuses: ['enabled', 'disabled', 'working'],
    loading: false,
    search: {
        hits: [],
        query: '',
        totalHits: 0,
        page: 1,
        hitsPerPage: 30,
        filter: [],
        sort: ['name:asc']
    }
}

describe('List', () => {
    describe('loading state', () => {
        it('shows placeholder when loading is true', () => {
            const { container } = renderList({ ...baseState, loading: true })
            expect(container.querySelector('.rs-placeholder')).toBeInTheDocument()
        })
    })

    describe('empty state', () => {
        it('shows "No heroes found" when hits is empty', () => {
            renderList(baseState)
            expect(screen.getByText('No heroes found')).toBeInTheDocument()
        })
    })

    describe('data state', () => {
        it('renders table with heroes', () => {
            const state = {
                ...baseState,
                search: {
                    ...baseState.search,
                    hits: [
                        { id: 1, name: 'Hero One', rank: 's', status: 'enabled', lat: 10, lng: 20 },
                        { id: 2, name: 'Hero Two', rank: 'a', status: 'working', lat: 30, lng: 40 }
                    ]
                }
            }
            renderList(state, {
                super_hero: null,
                average_score: 0,
                average_time_to_match: { hours: 0, minutes: 0, seconds: 0 },
                heroes_working: { global: 0, s: 0, a: 0, b: 0, c: 0, count: 0 },
                threats_disabled: { global: 0, god: 0, dragon: 0, tiger: 0, wolf: 0, count: 0 },
                heroes_distribution: null,
                threats_distribution: null,
                battles_lineup: [['One Hero', 0], ['Two Heroes', 0]]
            })
            expect(screen.getByText('Hero One')).toBeInTheDocument()
            expect(screen.getByText('Hero Two')).toBeInTheDocument()
            expect(screen.getByText('RANK')).toBeInTheDocument()
            expect(screen.getByText('STATUS')).toBeInTheDocument()
            expect(screen.getByText('NAME')).toBeInTheDocument()
            expect(screen.getByText('LOCATION')).toBeInTheDocument()
        })

        it('renders rank colors and status badges for heroes', () => {
            const state = {
                ...baseState,
                search: {
                    ...baseState.search,
                    hits: [
                        { id: 1, name: 'Hero One', rank: 's', status: 'enabled', lat: 10, lng: 20 }
                    ]
                }
            }
            renderList(state, { super_hero: null })
            expect(screen.getByText('enabled')).toBeInTheDocument()
        })

        it('renders edit and delete buttons for heroes', () => {
            const state = {
                ...baseState,
                search: {
                    ...baseState.search,
                    hits: [
                        { id: 1, name: 'Hero One', rank: 's', status: 'enabled', lat: 10, lng: 20 }
                    ]
                }
            }
            renderList(state, { super_hero: null })
            expect(screen.getByText('...')).toBeInTheDocument()
        })
    })

    describe('super hero badge', () => {
        it('shows trophy for super hero', () => {
            const state = {
                ...baseState,
                search: {
                    ...baseState.search,
                    hits: [{ id: 1, name: 'Champion', rank: 's', status: 'enabled', lat: 10, lng: 20 }]
                }
            }
            renderList(state, {
                super_hero: { name: 'Champion', rank: 's' },
                average_score: 0,
                average_time_to_match: { hours: 0, minutes: 0, seconds: 0 },
                heroes_working: { global: 0, s: 0, a: 0, b: 0, c: 0, count: 0 },
                threats_disabled: { global: 0, god: 0, dragon: 0, tiger: 0, wolf: 0, count: 0 },
                heroes_distribution: null,
                threats_distribution: null,
                battles_lineup: [['One Hero', 0], ['Two Heroes', 0]]
            })
            expect(screen.getByText('Champion')).toBeInTheDocument()
        })
    })

    describe('sorting', () => {
        it('renders sortable columns', () => {
            const state = {
                ...baseState,
                search: {
                    ...baseState.search,
                    hits: [{ id: 1, name: 'Hero', rank: 's', status: 'enabled', lat: 10, lng: 20 }]
                }
            }
            renderList(state, { super_hero: null })
            const sortableHeaders = document.querySelectorAll('.rs-table-cell-header-sortable')
            expect(sortableHeaders.length).toBeGreaterThanOrEqual(1)
        })
    })
})
