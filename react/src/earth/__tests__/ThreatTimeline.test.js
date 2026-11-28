import { render, screen } from '@testing-library/react'
import { MantineProvider } from '@mantine/core'
import ThreatTimeline from '../ThreatTimeline'

const events = [
    {
        id: 'event-1',
        type: 'AlertReceived',
        title: 'Threat detected',
        occurred_at: '2024-01-15T10:00:00Z',
        details: { monsterName: 'Godzilla', dangerLevel: 'God' }
    },
    {
        id: 'event-2',
        type: 'ResourceAllocated',
        title: 'Heroes allocated',
        occurred_at: '2024-01-15T10:01:00Z',
        details: { heroes: [{ name: 'Superman', rank: 's' }] }
    }
]

const renderTimeline = props => render(
    <MantineProvider><ThreatTimeline {...props} /></MantineProvider>
)

describe('ThreatTimeline', () => {
    it('renders a compact item per RES event', () => {
        renderTimeline({ events })

        expect(screen.getByTestId('threat-timeline')).toBeInTheDocument()
        expect(screen.getByText('Threat detected')).toBeInTheDocument()
        expect(screen.getByText('Heroes allocated')).toBeInTheDocument()
        expect(screen.getByText(/AlertReceived/)).toBeInTheDocument()
        expect(screen.getByText(/monsterName:/)).toBeInTheDocument()
        expect(screen.getByText(/Superman/)).toBeInTheDocument()
    })

    it('renders the first point and line in gray like the subsequent events', () => {
        renderTimeline({ events })

        const items = events.map((_, index) => screen.getByTestId(`threat-timeline-item-${index}`))
        items.forEach(item => {
            expect(item).toHaveStyle('--tli-color: var(--mantine-color-gray-filled)')
            expect(item.querySelector('[data-active]').style.borderColor).toBe('')
        })
    })

    it('renders hero lists without numeric indexes', () => {
        renderTimeline({
            events: [{
                id: 'event-3',
                type: 'ResourceNotAllocated',
                title: 'No hero available',
                details: [{ name: 'Flash', rank: 'a' }, { name: 'Superman', rank: 's' }]
            }]
        })

        const first = screen.getByTestId('timeline-detail-0')
        expect(first).toHaveTextContent('Flash')
        expect(first.textContent).toMatch(/^aFlash/)
        expect(screen.getByTestId('timeline-detail-1')).toHaveTextContent('Superman')
        expect(screen.getByText('a')).toBeInTheDocument()
        expect(screen.getByText('s')).toBeInTheDocument()
        expect(screen.queryByText(/rank:/)).not.toBeInTheDocument()
        expect(screen.queryByText(/0: name:/)).not.toBeInTheDocument()
    })

    it('does not emit a DOM nesting warning for hero rank badges', () => {
        const errorSpy = jest.spyOn(console, 'error').mockImplementation(() => {})
        try {
            renderTimeline({
                events: [{
                    id: 'event-4',
                    type: 'ResourceNotAllocated',
                    title: 'No hero available',
                    details: [{ name: 'Flash', rank: 'a' }]
                }]
            })

            expect(errorSpy.mock.calls.flat().join(' ')).not.toMatch(/validateDOMNesting/)
        } finally {
            errorSpy.mockRestore()
        }
    })

    it('renders an empty message when there are no events', () => {
        renderTimeline({ events: [] })
        expect(screen.getByText('No events recorded for this threat.')).toBeInTheDocument()
    })
})
