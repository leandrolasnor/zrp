import reducer from '../reducer'

const INITIAL_STATE = {
    threats: [],
    hovered: null,
    selected: null,
    rotation: 0,
    tilt: 0
}

describe('earth reducer', () => {
    it('returns initial state', () => {
        expect(reducer(undefined, {})).toEqual(INITIAL_STATE)
    })

    it('sets the threats from the historical endpoint', () => {
        const threats = [{ id: 1, name: 'Godzilla', events: [] }]
        const state = reducer(undefined, { type: 'EARTH_THREATS_FETCHED', payload: threats })
        expect(state.threats).toEqual(threats)
    })

    it('tracks the hovered point', () => {
        const state = reducer(undefined, { type: 'EARTH_THREAT_HOVERED', payload: 1 })
        expect(state.hovered).toBe(1)
    })

    it('opens and closes the details modal', () => {
        const threat = { id: 1, name: 'Godzilla' }
        const opened = reducer(undefined, { type: 'EARTH_THREAT_SELECTED', payload: threat })
        expect(opened.selected).toEqual(threat)
        expect(opened.hovered).toBeNull()

        const closed = reducer(opened, { type: 'EARTH_THREAT_CLOSED' })
        expect(closed.selected).toBeNull()
    })

    it('updates the globe rotation and tilt', () => {
        const state = reducer(undefined, {
            type: 'EARTH_ROTATION_CHANGED',
            payload: { rotation: 45, tilt: -20 }
        })
        expect(state.rotation).toBe(45)
        expect(state.tilt).toBe(-20)
    })
})
