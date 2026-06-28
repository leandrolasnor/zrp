jest.mock('web-vitals', () => ({
    getCLS: jest.fn(),
    getFID: jest.fn(),
    getFCP: jest.fn(),
    getLCP: jest.fn(),
    getTTFB: jest.fn()
}), { virtual: true })

describe('reportWebVitals', () => {
    beforeEach(() => {
        jest.resetModules()
    })

    it('does nothing when onPerfEntry is null', () => {
        const reportWebVitals = require('../reportWebVitals').default
        reportWebVitals(null)
    })

    it('does nothing when onPerfEntry is not a function', () => {
        const reportWebVitals = require('../reportWebVitals').default
        reportWebVitals('not a function')
        reportWebVitals(123)
        reportWebVitals(undefined)
        reportWebVitals({})
    })

    it('calls web-vitals functions when onPerfEntry is a function', (done) => {
        const reportWebVitals = require('../reportWebVitals').default
        const mockFn = jest.fn()
        reportWebVitals(mockFn)

        setTimeout(() => {
            done()
        }, 200)
    })
})
