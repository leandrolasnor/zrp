import rootReducer from '../reducers'

describe('rootReducer', () => {
    it('combines reducers and returns initial state', () => {
        const state = rootReducer(undefined, {})
        expect(state).toHaveProperty('metrics')
        expect(state).toHaveProperty('heroes')
        expect(state).toHaveProperty('toastr')
    })

    it('handles metrics actions', () => {
        const state = rootReducer(undefined, { type: 'METRICS_FETCHED', payload: { super_hero: 'Test' } })
        expect(state.metrics.super_hero).toBe('Test')
    })

    it('handles heroes actions', () => {
        const state = rootReducer(undefined, { type: 'RANKS_FETCHED', payload: ['s', 'a'] })
        expect(state.heroes.ranks).toEqual(['s', 'a'])
    })
})
