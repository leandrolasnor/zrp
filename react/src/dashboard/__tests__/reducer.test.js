import reducer from '../reducer'

const INITIAL_STATE = {
    loading: false,
    super_hero: null,
    historical_threats: [],
    average_score: 0,
    average_time_to_match: { hours: 0, minutes: 0, seconds: 0 },
    heroes_working: { global: 0, s: 0, a: 0, b: 0, c: 0, count: 0 },
    threats_disabled: { global: 0, god: 0, dragon: 0, tiger: 0, wolf: 0, count: 0 },
    heroes_distribution: null,
    threats_distribution: null,
    battles_lineup: [
        ['One Hero', 0],
        ['Two Heroes', 0]
    ]
}

describe('dashboard reducer', () => {
    it('returns initial state', () => {
        expect(reducer(undefined, {})).toEqual(INITIAL_STATE)
    })

    describe('METRICS_LOADING', () => {
        it('sets loading to true', () => {
            const state = reducer(undefined, { type: 'METRICS_LOADING' })
            expect(state.loading).toBe(true)
        })
    })

    describe('METRICS_FETCHED', () => {
        it('merges payload and sets loading false', () => {
            const payload = { average_score: 85, heroes_working: { global: 50 } }
            const state = reducer(undefined, { type: 'METRICS_FETCHED', payload })
            expect(state.loading).toBe(false)
            expect(state.average_score).toBe(85)
            expect(state.heroes_working.global).toBe(50)
        })
    })

    describe('HISTORICAL_THREATS_FETCHED', () => {
        it('sets historical_threats', () => {
            const threats = [{ id: 1, name: 'Threat 1' }]
            const state = reducer(undefined, { type: 'HISTORICAL_THREATS_FETCHED', payload: threats })
            expect(state.historical_threats).toEqual(threats)
        })
    })

    describe('WIDGET_HEROES_WORKING_FETCHED', () => {
        it('sets heroes_working', () => {
            const state = reducer(undefined, { type: 'WIDGET_HEROES_WORKING_FETCHED', payload: { global: 75 } })
            expect(state.heroes_working).toEqual({ global: 75 })
        })
    })

    describe('WIDGET_THREATS_DISABLED_FETCHED', () => {
        it('sets threats_disabled', () => {
            const state = reducer(undefined, { type: 'WIDGET_THREATS_DISABLED_FETCHED', payload: { global: 25 } })
            expect(state.threats_disabled).toEqual({ global: 25 })
        })
    })

    describe('WIDGET_BATTLES_LINEUP_FETCHED', () => {
        it('sets battles_lineup', () => {
            const lineup = [['One Hero', 10], ['Two Heroes', 5]]
            const state = reducer(undefined, { type: 'WIDGET_BATTLES_LINEUP_FETCHED', payload: lineup })
            expect(state.battles_lineup).toEqual(lineup)
        })
    })

    describe('WIDGET_AVERAGE_SCORE_FETCHED', () => {
        it('sets average_score', () => {
            const state = reducer(undefined, { type: 'WIDGET_AVERAGE_SCORE_FETCHED', payload: 92 })
            expect(state.average_score).toBe(92)
        })
    })

    describe('WIDGET_AVERAGE_TIME_TO_MATCH_FETCHED', () => {
        it('sets average_time_to_match', () => {
            const state = reducer(undefined, { type: 'WIDGET_AVERAGE_TIME_TO_MATCH_FETCHED', payload: { hours: 1, minutes: 30, seconds: 0 } })
            expect(state.average_time_to_match).toEqual({ hours: 1, minutes: 30, seconds: 0 })
        })
    })

    describe('WIDGET_SUPER_HERO_FETCHED', () => {
        it('sets super_hero', () => {
            const hero = { name: 'Superman', rank: 's' }
            const state = reducer(undefined, { type: 'WIDGET_SUPER_HERO_FETCHED', payload: hero })
            expect(state.super_hero).toEqual(hero)
        })
    })

    describe('WIDGET_THREATS_DISTRIBUTION_FETCHED', () => {
        it('sets threats_distribution', () => {
            const dist = { god: 5, dragon: 10 }
            const state = reducer(undefined, { type: 'WIDGET_THREATS_DISTRIBUTION_FETCHED', payload: dist })
            expect(state.threats_distribution).toEqual(dist)
        })
    })

    describe('WIDGET_HEROES_DISTRIBUTION_FETCHED', () => {
        it('sets heroes_distribution', () => {
            const dist = { s: 3, a: 7 }
            const state = reducer(undefined, { type: 'WIDGET_HEROES_DISTRIBUTION_FETCHED', payload: dist })
            expect(state.heroes_distribution).toEqual(dist)
        })
    })

    describe('SET_INSURGENCY', () => {
        it('passes through as-is (no case handler)', () => {
            const state = reducer(INITIAL_STATE, { type: 'SET_INSURGENCY', payload: 5000 })
            expect(state).toEqual(INITIAL_STATE)
        })
    })
})
