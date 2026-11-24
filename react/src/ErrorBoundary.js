import React from 'react'
import { Paper, Title, Text, Button, Code } from '@mantine/core'
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
        <Paper withBorder p="md" style={{ margin: 20, maxWidth: 600 }}>
          <Title order={4}>Something went wrong</Title>
          <Text mb="sm">
            An unexpected error occurred. Please try refreshing the page.
          </Text>
          {process.env.NODE_ENV === 'development' && this.state.error && (
            <Code block style={{ fontSize: 12, overflow: 'auto', maxHeight: 300 }}>
              {this.state.error.toString()}
              {this.state.errorInfo?.componentStack}
            </Code>
          )}
          <Button mt="sm" onClick={this.handleReset}>
            Try again
          </Button>
        </Paper>
      )
    }

    return this.props.children
  }
}

ErrorBoundary.propTypes = {
  children: PropTypes.node,
}

export default ErrorBoundary
