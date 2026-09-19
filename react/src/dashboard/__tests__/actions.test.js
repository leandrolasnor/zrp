import axios from 'axios'
import { historical_threats, set_insurgency, connect_widgets_stream, disconnect_widgets_stream } from '../actions'
import ACTION_TYPES from '../action_types'

jest.mock('axios')

const mockDispatch = jest.fn()

describe('dashboard actions', () => {
    afterEach(() => {
        jest.clearAllMocks()
    })

    describe('widgets stream', () => {
        const listeners = {}
        let eventSourceMock
        let originalEventSource
        let dispatched

        const dispatch = action => {
            if (typeof action === 'function') {
                return action(dispatch)
            }
            dispatched.push(action)
            return action
        }

        beforeEach(() => {
            jest.useFakeTimers()
            originalEventSource = global.EventSource
            dispatched = []
            Object.keys(listeners).forEach(key => delete listeners[key])
            eventSourceMock = {
                addEventListener: jest.fn((type, callback) => { listeners[type] = callback }),
                close: jest.fn(),
                onopen: null,
                onerror: null,
            }
            global.EventSource = jest.fn(() => eventSourceMock)
            dispatch(disconnect_widgets_stream())
        })

        afterEach(() => {
            jest.useRealTimers()
            global.EventSource = originalEventSource
        })

        it('connects to the widgets stream and registers a listener for each action type', () => {
            dispatch(connect_widgets_stream())

            expect(global.EventSource).toHaveBeenCalledWith('/v1/sse/widgets')
            expect(eventSourceMock.addEventListener).toHaveBeenCalledTimes(ACTION_TYPES.size)
        })

        it('dispatches the action type with parsed payload on received event', () => {
            dispatch(connect_widgets_stream())

            listeners['WIDGET_AVERAGE_SCORE_FETCHED']({ data: JSON.stringify({ average_score: 85 }) })

            expect(dispatched).toContainEqual({ type: 'WIDGET_AVERAGE_SCORE_FETCHED', payload: { average_score: 85 } })
        })

        it('logs an error and does not dispatch on invalid JSON', () => {
            const errorSpy = jest.spyOn(console, 'error').mockImplementation(() => { })
            dispatch(connect_widgets_stream())

            listeners['WIDGET_AVERAGE_SCORE_FETCHED']({ data: 'not-json' })

            expect(dispatched).toHaveLength(0)
            expect(errorSpy).toHaveBeenCalled()
            errorSpy.mockRestore()
        })

        it('reconnects after 5 seconds on error', () => {
            dispatch(connect_widgets_stream())

            eventSourceMock.onerror(new Error('boom'))
            expect(eventSourceMock.close).toHaveBeenCalled()

            jest.advanceTimersByTime(4999)
            expect(global.EventSource).toHaveBeenCalledTimes(1)

            jest.advanceTimersByTime(1)
            expect(global.EventSource).toHaveBeenCalledTimes(2)
        })

        it('disconnects and cancels pending reconnect', () => {
            dispatch(connect_widgets_stream())

            eventSourceMock.onerror(new Error('boom'))
            dispatch(disconnect_widgets_stream())

            jest.advanceTimersByTime(5000)
            expect(global.EventSource).toHaveBeenCalledTimes(1)
            expect(eventSourceMock.close).toHaveBeenCalled()
        })
    })

    describe('historical_threats', () => {
        it('dispatches HISTORICAL_THREATS_FETCHED on success', async () => {
            const resp = { data: [{ id: 1, name: 'Threat' }] }
            axios.get.mockResolvedValue(resp)

            await historical_threats({ page: 1, per_page: 50 })(mockDispatch)

            expect(axios.get).toHaveBeenCalledWith('/v1/threats/historical', {
                params: { page: 1, per_page: 50 }
            })
            expect(mockDispatch).toHaveBeenCalledWith({ type: 'HISTORICAL_THREATS_FETCHED', payload: resp.data })
        })

        it('does not dispatch HISTORICAL_THREATS_FETCHED on API error', async () => {
            axios.get.mockRejectedValue(new Error('Network Error'))

            await historical_threats({})(mockDispatch)

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
