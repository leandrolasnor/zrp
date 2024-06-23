import { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Input, InputGroup, IconButton, Row, Col } from 'rsuite'
import HeroForm from './hero_form.js'
import SearchIcon from '@rsuite/icons/Search'
import PlusIcon from '@rsuite/icons/Plus'

const Searcher = props => {
  const { search: { query } } = useSelector(state => state.heroes)
  const searchRef = useRef(null)
  const dispatch = useDispatch()
  const [openCreateHeroForm, setOpenCreateHeroForm] = useState(false)
  const keyDownSearchHandler = event => {
    if (event.key === 'Escape') {
      event.preventDefault()
      searchRef.current.value = ''
    } else if (event.key === 'Enter') {
      event.preventDefault()
      dispatch({ type: 'QUERY_CHANGED', payload: searchRef.current.value })
    }
  }

  const CustomInputGroupWidthButton = ({ placeholder, ...props }) => (
    <InputGroup {...props} inside>
      <Input placeholder={placeholder} autoFocus onKeyDown={keyDownSearchHandler} ref={searchRef} />
      <InputGroup.Button onClick={() => dispatch({ type: 'QUERY_CHANGED', payload: searchRef.current.value })}>
        <SearchIcon />
      </InputGroup.Button>
    </InputGroup>
  )

  useEffect(() => { searchRef.current.value = query })
  return (
    <Row className='mt-3'>
      <Col xs={22}>
        <CustomInputGroupWidthButton size="md" placeholder="Search" />
      </Col>
      <Col xs={2}>
        <IconButton onClick={() => setOpenCreateHeroForm(true)} icon={<PlusIcon />}>Hero</IconButton>
      </Col>
      <HeroForm size='xs' open={openCreateHeroForm} textButton='Save' title='New Hero' handleClose={() => setOpenCreateHeroForm(false)} />
    </Row>
  )
}

export default Searcher
