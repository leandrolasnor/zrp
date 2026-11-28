import axios from 'axios'
import handle_errors from '../../handleErrors'
import { fetch_earth_threats, hover_threat, select_threat, close_threat, rotate_earth } from '../actions'

jest.mock('axios')
jest.mock('../../handleErrors', () => jest.fn())

const mockDispatch = jest.fn()

describe('earth actions', () => {
    afterEach(() => {
        jest.clearAllMocks()
    })

    describe('fetch_earth_threats', () => {
        it('dispatches EARTH_THREATS_FETCHED on success', async () => {
            const resp = { data: [{ id: 1, name: 'Godzilla' }] }
            axios.get.mockResolvedValue(resp)

            const data = await fetch_earth_threats({ page: 1, per_page: 50 })(mockDispatch)

            expect(axios.get).toHaveBeenCalledWith('/v1/threats/historical', {
                params: { page: 1, per_page: 50 }
            })
            expect(mockDispatch).toHaveBeenCalledWith({ type: 'EARTH_THREATS_FETCHED', payload: resp.data })
            expect(data).toEqual(resp.data)
        })

        it('handles the error without dispatching on failure', async () => {
            const error = new Error('Network Error')
            axios.get.mockRejectedValue(error)

            await fetch_earth_threats({})(mockDispatch)

            expect(handle_errors).toHaveBeenCalledWith(error)
            expect(mockDispatch).not.toHaveBeenCalled()
        })
    })

    describe('UI actions', () => {
        it('creates hover, select, close and rotate actions', () => {
            const threat = { id: 1, name: 'Godzilla' }

            expect(hover_threat(1)).toEqual({ type: 'EARTH_THREAT_HOVERED', payload: 1 })
            expect(select_threat(threat)).toEqual({ type: 'EARTH_THREAT_SELECTED', payload: threat })
            expect(close_threat()).toEqual({ type: 'EARTH_THREAT_CLOSED' })
            expect(rotate_earth({ rotation: 90, tilt: 10 })).toEqual({
                type: 'EARTH_ROTATION_CHANGED',
                payload: { rotation: 90, tilt: 10 }
            })
        })
    })
})
