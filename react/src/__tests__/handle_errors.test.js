import handle_errors from '../handleErrors'

jest.mock('react-redux-toastr', () => ({
  toastr: { error: jest.fn() }
}))

const { toastr } = require('react-redux-toastr')

describe('handle_errors', () => {
  afterEach(() => {
    jest.clearAllMocks()
  })

  describe('with response.data array', () => {
    it('calls toastr for each entry', () => {
      const e = { response: { data: [['name', ["can't be blank"]]] } }
      handle_errors(e)
      expect(toastr.error).toHaveBeenCalled()
    })

    it('handles non-array, non-string values in array entries', () => {
      const e = { response: { data: [{ field: 'value' }] } }
      handle_errors(e)
      expect(toastr.error).toHaveBeenCalled()
    })

    it('handles string values in array entries', () => {
      const e = { response: { data: ['simple error'] } }
      handle_errors(e)
      expect(toastr.error).toHaveBeenCalled()
    })
  })

  describe('with response.data string', () => {
    it('shows the string as error', () => {
      const e = { response: { data: 'Internal server error' } }
      handle_errors(e)
      expect(toastr.error).toHaveBeenCalledWith('Error', 'Internal server error')
    })
  })

  describe('with response.data object (not string, not array)', () => {
    it('silently ignores non-array non-string response.data', () => {
      const e = { response: { data: { some: 'object' } } }
      handle_errors(e)
      expect(toastr.error).not.toHaveBeenCalled()
    })
  })

  describe('with response but no data', () => {
    it('shows status code and text', () => {
      const e = { response: { status: 404, statusText: 'Not Found' } }
      handle_errors(e)
      expect(toastr.error).toHaveBeenCalledWith('404', 'Not Found')
    })
  })

  describe('Network Error', () => {
    it('shows network error message', () => {
      const e = { message: 'Network Error' }
      handle_errors(e)
      expect(toastr.error).toHaveBeenCalledWith('API', 'Network Error')
    })
  })

  describe('unknown error', () => {
    it('falls back to error message', () => {
      const e = { message: 'something broke' }
      handle_errors(e)
      expect(toastr.error).toHaveBeenCalledWith('Error', 'something broke')
    })

    it('falls back to unknown error', () => {
      const e = {}
      handle_errors(e)
      expect(toastr.error).toHaveBeenCalledWith('Error', 'unknown error')
    })
  })
})
