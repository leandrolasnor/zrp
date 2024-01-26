import { Input, InputGroup, IconButton, Col } from 'rsuite'
import SearchIcon from '@rsuite/icons/Search'
import PlusIcon from '@rsuite/icons/Plus'
import { styled } from 'styled-components'

const CustomInputGroupWidthButton = ({ placeholder, ...props }) => (
  <InputGroup {...props} inside>
    <Input placeholder={placeholder} />
    <InputGroup.Button>
      <SearchIcon />
    </InputGroup.Button>
  </InputGroup>
)

const CustomInputGroupWidthButtonStyled = styled(CustomInputGroupWidthButton)`
  marginBottom: 10
`

const Searcher = props => {
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
