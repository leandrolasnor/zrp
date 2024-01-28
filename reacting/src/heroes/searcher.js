import { useEffect, useRef } from 'react'
import { useDispatch } from 'react-redux'
import { Input, InputGroup, IconButton, Col } from 'rsuite'
import SearchIcon from '@rsuite/icons/Search'
import PlusIcon from '@rsuite/icons/Plus'
import { styled } from 'styled-components'

const Searcher = props => {
  const searchRef = useRef(null);
  const dispatch = useDispatch()

  useEffect(() => {
    const keyDownHandler = event => {
      if (event.key === 'Escape') {
        event.preventDefault()
        searchRef.current.value = ''
      }else if(event.key ==='Enter'){
        event.preventDefault()
        dispatch({ type: 'QUERY_CHANGED', payload: searchRef.current.value })
      }
    }

    document.addEventListener('keydown', keyDownHandler)

    return () => {
      document.removeEventListener('keydown', keyDownHandler)
    }
  }, [])

  const CustomInputGroupWidthButton = ({ placeholder, ...props }) => (
    <InputGroup {...props} inside>
      <Input placeholder={placeholder} autoFocus ref={searchRef} />
      <InputGroup.Button onClick={() => dispatch({ type: 'QUERY_CHANGED', payload: searchRef.current.value })}>
        <SearchIcon />
      </InputGroup.Button>
    </InputGroup>
  )

  const CustomInputGroupWidthButtonStyled = styled(CustomInputGroupWidthButton)`
    marginBottom: 10
  `

  return (
    <>
      <Col xs={22}>
        <CustomInputGroupWidthButton size="md" placeholder="Search" />
      </Col>
      <Col xs={2}>
        <IconButton icon={<PlusIcon />}>Hero</IconButton>
      </Col>
    </>
  )
}

export default Searcher
