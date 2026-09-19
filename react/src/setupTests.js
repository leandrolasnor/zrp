// jest-dom adds custom jest matchers for asserting on DOM nodes.
// allows you to do things like:
// expect(element).toHaveTextContent(/react/i)
// learn more: https://github.com/testing-library/jest-dom
import '@testing-library/jest-dom';

class MockEventSource {
  static instances = []
  static CONNECTING = 0
  static OPEN = 1
  static CLOSED = 2

  onopen = null
  onerror = null
  onmessage = null
  readyState = MockEventSource.CONNECTING

  constructor(url) {
    this.url = url
    MockEventSource.instances.push(this)
  }

  addEventListener() { }
  close() {
    this.readyState = MockEventSource.CLOSED
  }
}

global.EventSource = MockEventSource
