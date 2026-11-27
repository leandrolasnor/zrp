import { render, screen, fireEvent, within, cleanup } from '@testing-library/react'
import { Provider } from 'react-redux'
import { MantineProvider } from '@mantine/core'
import { configureStore } from '@reduxjs/toolkit'
import HeroForm from '../HeroForm'
import reducer from '../reducer'
import { rankColors, rankTextColor } from '../rankColors'

beforeAll(() => {
    global.ResizeObserver = class {
        observe () { }
        unobserve () { }
        disconnect () { }
    }
})

afterEach(cleanup)

jest.mock('../actions', () => ({
    create_hero: () => () => Promise.resolve({ id: 1 }),
    update_hero: () => () => Promise.resolve({ id: 1 }),
    get_ranks: () => ({ type: 'RANKS_FETCHED', payload: ['s', 'a', 'b', 'c'] })
}))

const renderHeroForm = (props = {}) => {
    const store = configureStore({
        reducer: { heroes: reducer },
        preloadedState: {
            heroes: {
                ranks: ['s', 'a', 'b', 'c'],
                statuses: ['enabled', 'disabled', 'working'],
                loading: false,
                search: {
                    hits: [],
                    query: '',
                    totalHits: 0,
                    page: 1,
                    hitsPerPage: 30,
                    filter: [],
                    sort: ['name:asc']
                }
            }
        }
    })
    return render(
        <MantineProvider>
            <Provider store={store}><HeroForm size='xs' open={true} textButton='Save' title='New Hero' handleClose={() => { }} {...props} /></Provider>
        </MantineProvider>
    )
}

describe('HeroForm', () => {
    it('renders modal when open', () => {
        renderHeroForm()
        expect(screen.getByText('New Hero')).toBeInTheDocument()
    })

    it('renders form fields', () => {
        renderHeroForm()
        expect(screen.getByText('Name')).toBeInTheDocument()
        expect(screen.getByText('Rank')).toBeInTheDocument()
        expect(screen.getByText('Latitude')).toBeInTheDocument()
        expect(screen.getByText('Longitude')).toBeInTheDocument()
    })

    it('renders cancel and save buttons', () => {
        renderHeroForm()
        expect(screen.getByText('Cancel')).toBeInTheDocument()
        expect(screen.getByText('Save')).toBeInTheDocument()
    })

    it('renders update title when provided', () => {
        renderHeroForm({ title: 'Update Hero', textButton: 'Update' })
        expect(screen.getByText('Update Hero')).toBeInTheDocument()
        expect(screen.getByText('Update')).toBeInTheDocument()
    })

    it('renders with data pre-filled for update', () => {
        renderHeroForm({
            title: 'Update Hero',
            data: { id: 1, name: 'Existing Hero', rank: 's', lat: '10', lng: '20' }
        })
        expect(screen.getByText('Update Hero')).toBeInTheDocument()
    })

    it('does not render modal when closed', () => {
        const store = configureStore({
            reducer: { heroes: reducer },
            preloadedState: {
                heroes: {
                    ranks: ['s', 'a'],
                    statuses: [],
                    loading: false,
                    search: { hits: [], query: '', totalHits: 0, page: 1, hitsPerPage: 30, filter: [], sort: ['name:asc'] }
                }
            }
        })
        const { container } = render(
            <MantineProvider>
                <Provider store={store}>
                    <HeroForm size='xs' open={false} textButton='Save' title='New Hero' handleClose={() => { }} />
                </Provider>
            </MantineProvider>
        )
        expect(screen.queryByText('New Hero')).not.toBeInTheDocument()
    })

    it('calls handleClose when Cancel is clicked', () => {
        const handleClose = jest.fn()
        renderHeroForm({ handleClose })
        const cancelButton = screen.getByText('Cancel').closest('button')
        if (cancelButton) {
            fireEvent.click(cancelButton)
        }
        expect(handleClose).toHaveBeenCalled()
    })

    it('paints each rank option with the same color as the hero list', () => {
        const { baseElement } = renderHeroForm()
        fireEvent.click(within(baseElement).getByRole('textbox', { name: 'Rank' }))
        const options = within(baseElement).getByRole('listbox')
        Object.entries(rankColors).forEach(([rank, color]) => {
            const badge = within(options).getByText(rank.toUpperCase()).closest('.mantine-Badge-root')
            expect(badge).toHaveAttribute('style', expect.stringContaining(`--badge-bg: var(--mantine-color-${color}-light)`))
        })
    })

    it('paints the selected rank with the same color as the hero list', () => {
        const { baseElement } = renderHeroForm({ data: { id: 1, name: 'Existing Hero', rank: 's', lat: '10', lng: '20' } })
        // jsdom drops CSS var() from the color property, so the shared helper is asserted directly
        expect(rankTextColor('s')).toBe(`var(--mantine-color-${rankColors.s}-6)`)
        expect(rankTextColor('')).toBeUndefined()
        expect(within(baseElement).getByRole('textbox', { name: 'Rank' })).toHaveStyle('font-weight: 700')
    })
})
