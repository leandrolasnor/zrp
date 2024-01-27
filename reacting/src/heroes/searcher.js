import { useEffect, useState } from 'react'
import { useDispatch } from 'react-redux'
import { Input, InputGroup, IconButton, Col } from 'rsuite'
import SearchIcon from '@rsuite/icons/Search'
import PlusIcon from '@rsuite/icons/Plus'
import { styled } from 'styled-components'
import { list } from './actions.js'

const Searcher = props => {
  const dispatch = useDispatch()
  const [page, setPage] = useState(0)
  const [per_page, setPerPage] = useState(25)
  const pagination = { page: page, per_page: per_page }

  useEffect(() => {
    page > 0 ? dispatch(list(pagination)) : setPage(1)
  }, [dispatch, page])

  const CustomInputGroupWidthButton = ({ placeholder, ...props }) => (
    <InputGroup {...props} inside>
      <Input placeholder={placeholder} />
      <InputGroup.Button onClick={() => dispatch(list(pagination))}>
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
        <CustomInputGroupWidthButtonStyled size="md" placeholder="Search" />
      </Col>
      <Col xs={2}>
        <IconButton icon={<PlusIcon />}>Hero</IconButton>
      </Col>
    </>
  )
}

export default Searcher
