import React from 'react'
import { Panel, Button, Placeholder } from 'rsuite'
import PropTypes from 'prop-types'

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props)
    this.state = { hasError: false, error: null, errorInfo: null }
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error }
  }

  componentDidCatch(error, errorInfo) {
    this.setState({ errorInfo })
    if (process.env.NODE_ENV === 'development') {
      console.error('ErrorBoundary caught:', error, errorInfo)
    }
  }

  handleReset = () => {
    this.setState({ hasError: false, error: null, errorInfo: null })
  }

  render() {
    if (this.state.hasError) {
      return (
        <Panel
          header="Something went wrong"
          bordered
          style={{ margin: 20, maxWidth: 600 }}
        >
          <p style={{ marginBottom: 10 }}>
            An unexpected error occurred. Please try refreshing the page.
          </p>
          {process.env.NODE_ENV === 'development' && this.state.error && (
            <Placeholder.Paragraph rows={8}>
              <pre style={{ fontSize: 12, overflow: 'auto' }}>
                {this.state.error.toString()}
                {this.state.errorInfo?.componentStack}
              </pre>
            </Placeholder.Paragraph>
          )}
          <Button appearance="primary" onClick={this.handleReset}>
            Try again
          </Button>
        </Panel>
      )
    }

    return this.props.children
  }
}

ErrorBoundary.propTypes = {
  children: PropTypes.node,
}

export default ErrorBoundary
