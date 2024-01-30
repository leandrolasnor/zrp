import { useEffect, useRef, useState } from 'react'
import { useDispatch } from 'react-redux'
import { Input, InputGroup, IconButton, Row, Col } from 'rsuite'
import HeroForm from './hero_form.js'
import SearchIcon from '@rsuite/icons/Search'
import PlusIcon from '@rsuite/icons/Plus'

const Searcher = props => {
  const {query} = props
  const searchRef = useRef(null)
  const dispatch = useDispatch()
  const [openHeroForm, setOpenHeroForm] = useState(false)

  useEffect(() => {
    searchRef.current.value = query
    const keyDownHandler = event => {
      if (event.key === 'Escape') {
        event.preventDefault()
        searchRef.current.value = ''
      } else if (event.key === 'Enter') {
        event.preventDefault()
        dispatch({ type: 'QUERY_CHANGED', payload: searchRef.current.value })
      }
    }

    document.addEventListener('keydown', keyDownHandler)

    return () => {
      document.removeEventListener('keydown', keyDownHandler)
    }
  })

  const CustomInputGroupWidthButton = ({ placeholder, ...props }) => (
    <InputGroup {...props} inside>
      <Input placeholder={placeholder} autoFocus ref={searchRef} />
      <InputGroup.Button onClick={() => dispatch({ type: 'QUERY_CHANGED', payload: searchRef.current.value })}>
        <SearchIcon />
      </InputGroup.Button>
    </InputGroup>
  )

  return (
    <Row className='mt-3'>
      <Col xs={22}>
        <CustomInputGroupWidthButton size="md" placeholder="Search" />
      </Col>
      <Col xs={2}>
        <IconButton onClick={() => setOpenHeroForm(!openHeroForm)} icon={<PlusIcon />}>Hero</IconButton>
      </Col>
      <HeroForm size='xs' open={openHeroForm} textButton='Save' handleClose={() => setOpenHeroForm(false)} />
    </Row>
  )
}

export default Searcher
