import { render, screen } from '@testing-library/react'
import { Provider } from 'react-redux'
import { configureStore } from '@reduxjs/toolkit'
import Heroes from '../Heroes'
import reducer from '../reducer'

jest.mock('../Filter', () => () => <div data-testid="filter">Filter</div>)
jest.mock('../Searcher', () => () => <div data-testid="searcher">Searcher</div>)
jest.mock('../List', () => () => <div data-testid="list">List</div>)
jest.mock('../Paginate', () => () => <div data-testid="paginate">Paginate</div>)

const renderHeroes = () => {
    const store = configureStore({ reducer: { heroes: reducer } })
    return render(<Provider store={store}><Heroes /></Provider>)
}

describe('Heroes', () => {
    it('renders all sub-components', () => {
        renderHeroes()
        expect(screen.getByTestId('filter')).toBeInTheDocument()
        expect(screen.getByTestId('searcher')).toBeInTheDocument()
        expect(screen.getByTestId('list')).toBeInTheDocument()
        expect(screen.getByTestId('paginate')).toBeInTheDocument()
    })
})
