import { render, screen, fireEvent, act, within } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import { MantineProvider } from '@mantine/core'
import Earth from '../Earth'
import reducer from '../reducer'
import metricsReducer from '../../dashboard/reducer'

let resolveLoading
jest.mock('../actions', () => ({
    fetch_earth_threats: () => () => new Promise(resolve => { resolveLoading = resolve }),
    hover_threat: id => ({ type: 'EARTH_THREAT_HOVERED', payload: id }),
    select_threat: threat => ({ type: 'EARTH_THREAT_SELECTED', payload: threat }),
    close_threat: () => ({ type: 'EARTH_THREAT_CLOSED' }),
    rotate_earth: position => ({ type: 'EARTH_ROTATION_CHANGED', payload: position })
}))

const godzilla = {
    id: 1,
    name: 'Godzilla',
    rank: 'god',
    lat: 10,
    lng: 20,
    battle: {
        score: 95,
        created_at: '2024-01-15T10:00:00Z',
        finished_at: '2024-01-15T10:05:00Z',
        duration: { hours: 0, minutes: 5, seconds: 0 },
        heroes: [{ name: 'Superman', rank: 's' }]
    },
    events: [
        {
            id: 'event-1',
            type: 'AlertReceived',
            title: 'Threat detected',
            occurred_at: '2024-01-15T10:00:00Z',
            details: { monsterName: 'Godzilla' }
        }
    ]
}

const renderEarth = threats => {
    const store = configureStore({
        reducer: { earth: reducer, metrics: metricsReducer },
        preloadedState: { earth: { threats, hovered: null, selected: null, rotation: 0, tilt: 0 } }
    })
    const result = render(
        <Provider store={store}>
            <MantineProvider><Earth /></MantineProvider>
        </Provider>
    )
    return { ...result, store }
}

describe('Earth', () => {
    beforeEach(() => {
        resolveLoading = undefined
    })

    it('shows the globe without points while fetching', () => {
        renderEarth([])
        expect(screen.getByText('Loading historical threats...')).toBeInTheDocument()
        expect(screen.getByTestId('earth-globe')).toBeInTheDocument()
        expect(document.querySelectorAll('[data-testid^="earth-point-"]')).toHaveLength(0)
    })

    it('shows the globe without points when there are no threats', async () => {
        renderEarth([])
        await act(async () => { resolveLoading() })
        expect(screen.getByText('No historical threats yet')).toBeInTheDocument()
        expect(screen.getByTestId('earth-globe')).toBeInTheDocument()
        expect(document.querySelectorAll('[data-testid^="earth-point-"]')).toHaveLength(0)
    })

    it('renders the interactive globe with one point per threat', async () => {
        renderEarth([godzilla])
        await act(async () => { resolveLoading() })

        expect(screen.getByTestId('earth-globe')).toBeInTheDocument()
        expect(screen.getByLabelText('Threat Godzilla')).toBeInTheDocument()
        expect(screen.getByRole('button', { name: /refresh historical threats/i })).toBeInTheDocument()
    })

    it('shows a tooltip with preliminary information on hover', async () => {
        renderEarth([godzilla])
        await act(async () => { resolveLoading() })

        fireEvent.mouseEnter(screen.getByLabelText('Threat Godzilla'))

        const tooltip = screen.getByTestId('earth-tooltip')
        expect(tooltip).toBeInTheDocument()
        expect(tooltip).toHaveTextContent('Godzilla')
        expect(tooltip).toHaveTextContent('95')
    })

    it('opens a modal with details and the RES timeline on click', async () => {
        renderEarth([godzilla])
        await act(async () => { resolveLoading() })

        fireEvent.click(screen.getByLabelText('Threat Godzilla'))

        const details = await screen.findByTestId('threat-details')
        const rank = screen.getByText('god')
        const name = screen.getByTestId('threat-title-name')
        expect(rank.compareDocumentPosition(name) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
        expect(within(details).queryByText('god')).not.toBeInTheDocument()
        expect(details).toHaveTextContent('10, 20')
        expect(details).toHaveTextContent('Score:')
        expect(screen.getByTestId('threat-score')).toHaveTextContent('95')
        expect(screen.getByText('Duration:').compareDocumentPosition(screen.getByText('0h 5.00min 0.00sec')) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
        expect(screen.getByText('Duration:').compareDocumentPosition(screen.getByText(/Score:/)) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
        expect(screen.getByText('Started:').compareDocumentPosition(screen.getByText('2024-01-15T10:00:00Z')) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
        expect(screen.getByText('Finished:').compareDocumentPosition(screen.getByText('2024-01-15T10:05:00Z')) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
        expect(details).toHaveTextContent('Superman')
        expect(details).toHaveTextContent('Threat detected')

        const heroes = screen.getByTestId('threat-heroes')
        expect(heroes).toHaveTextContent('Superman')
        expect(heroes.compareDocumentPosition(screen.getByText(/Score:/)) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()

        const divider = screen.getByTestId('threat-details-divider')
        expect(divider.compareDocumentPosition(screen.getByTestId('threat-timeline')) & Node.DOCUMENT_POSITION_FOLLOWING).toBeTruthy()
        expect(details).not.toHaveTextContent('Event timeline')
    })

    it('rotates the globe when dragged', async () => {
        const { store } = renderEarth([godzilla])
        await act(async () => { resolveLoading() })

        const globe = screen.getByTestId('earth-globe')
        fireEvent.mouseDown(globe, { clientX: 100, clientY: 100 })
        fireEvent.mouseMove(globe, { clientX: 150, clientY: 100 })

        expect(store.getState().earth.rotation).toBe(-25)
        expect(store.getState().earth.tilt).toBe(0)
    })
})
