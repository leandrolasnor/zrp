import { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Input, InputGroup, IconButton, Row, Col } from 'rsuite'
import HeroForm from './HeroForm.js'
import SearchIcon from '@rsuite/icons/Search'
import PlusIcon from '@rsuite/icons/Plus'
import PropTypes from 'prop-types'

const Searcher = () => {
  const { search: { query } } = useSelector(state => state.heroes)
  const dispatch = useDispatch()
  const [searchTerm, setSearchTerm] = useState(query)
  const [openCreateHeroForm, setOpenCreateHeroForm] = useState(false)

  useEffect(() => {
    setSearchTerm(query)
  }, [query])

  const submitSearch = () => {
    dispatch({ type: 'QUERY_CHANGED', payload: searchTerm })
  }

  const keyDownSearchHandler = (event) => {
    if (event.key === 'Escape') {
      event.preventDefault()
      setSearchTerm('')
      dispatch({ type: 'QUERY_CHANGED', payload: '' })
    } else if (event.key === 'Enter') {
      event.preventDefault()
      submitSearch()
    }
  }

  return (
    <Row className='mt-3'>
      <Col md={22}>
        <InputGroup inside>
          <Input
            placeholder="Search"
            autoFocus
            value={searchTerm}
            onChange={setSearchTerm}
            onKeyDown={keyDownSearchHandler}
          />
          <InputGroup.Button onClick={submitSearch}>
            <SearchIcon />
          </InputGroup.Button>
        </InputGroup>
      </Col>
      <Col md={2}>
        <IconButton onClick={() => setOpenCreateHeroForm(true)} icon={<PlusIcon />}>Hero</IconButton>
      </Col>
      <HeroForm size='xs' open={openCreateHeroForm} textButton='Save' title='New Hero' handleClose={() => setOpenCreateHeroForm(false)} />
    </Row>
  )
}

Searcher.propTypes = {}

export default Searcher