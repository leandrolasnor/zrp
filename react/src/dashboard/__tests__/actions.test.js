import axios from 'axios'
import { historical_threats, set_insurgency } from '../actions'

jest.mock('axios')

const mockDispatch = jest.fn()

describe('dashboard actions', () => {
    afterEach(() => {
        jest.clearAllMocks()
    })

    describe('historical_threats', () => {
        it('dispatches METRICS_LOADING and HISTORICAL_THREATS_FETCHED on success', async () => {
            const resp = { data: [{ id: 1, name: 'Threat' }] }
            axios.get.mockResolvedValue(resp)

            await historical_threats({ page: 1, per_page: 50 })(mockDispatch)

            expect(mockDispatch).toHaveBeenCalledWith({ type: 'METRICS_LOADING' })
            expect(axios.get).toHaveBeenCalledWith('/v1/threats/historical', {
                params: { page: 1, per_page: 50 }
            })
            expect(mockDispatch).toHaveBeenCalledWith({ type: 'HISTORICAL_THREATS_FETCHED', payload: resp.data })
        })

        it('dispatches METRICS_LOADING on API error', async () => {
            axios.get.mockRejectedValue(new Error('Network Error'))

            await historical_threats({})(mockDispatch)

            expect(mockDispatch).toHaveBeenCalledWith({ type: 'METRICS_LOADING' })
            expect(mockDispatch).not.toHaveBeenCalledWith({ type: 'HISTORICAL_THREATS_FETCHED', payload: expect.anything() })
        })
    })

    describe('set_insurgency', () => {
        it('dispatches SET_INSURGENCY on success', async () => {
            axios.post.mockResolvedValue({ data: { insurgency: 5000 } })

            await set_insurgency(5000)(mockDispatch)

            expect(axios.post).toHaveBeenCalledWith('/v1/threats/set_insurgency', { insurgency: 5000 })
            expect(mockDispatch).toHaveBeenCalledWith({ type: 'SET_INSURGENCY', payload: { insurgency: 5000 } })
        })

        it('does not dispatch on API error', async () => {
            axios.post.mockRejectedValue(new Error('Network Error'))

            await set_insurgency(5000)(mockDispatch)

            expect(mockDispatch).not.toHaveBeenCalledWith({ type: 'SET_INSURGENCY', payload: expect.anything() })
        })
    })
})
