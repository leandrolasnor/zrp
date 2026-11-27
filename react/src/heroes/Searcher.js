import { useEffect, useState, useRef } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { TextInput, Button, Group, ActionIcon } from '@mantine/core'
import { FaMagnifyingGlass, FaPlus } from 'react-icons/fa6'
import HeroForm from './HeroForm.js'

const Searcher = () => {
  const { search: { query, focusTick } } = useSelector(state => state.heroes)
  const dispatch = useDispatch()
  const inputRef = useRef(null)
  const [searchTerm, setSearchTerm] = useState(query)
  const [openCreateHeroForm, setOpenCreateHeroForm] = useState(false)

  useEffect(() => {
    setSearchTerm(query)
  }, [query])

  useEffect(() => {
    if (focusTick > 0 && inputRef.current) {
      inputRef.current.focus()
    }
  }, [focusTick])

  const submitSearch = () => {
    dispatch({ type: 'QUERY_CHANGED', payload: searchTerm })
    dispatch({ type: 'FOCUS_SEARCH_INPUT' })
  }

  const keyDownSearchHandler = (event) => {
    if (event.key === 'Escape') {
      event.preventDefault()
      setSearchTerm('')
      dispatch({ type: 'QUERY_CHANGED', payload: '' })
      dispatch({ type: 'CLEAR_FILTER' })
    } else if (event.key === 'Enter') {
      event.preventDefault()
      submitSearch()
    }
  }

  return (
    <Group mt="md" wrap="nowrap">
      <TextInput
        ref={inputRef}
        style={{ flex: 1 }}
        placeholder="Search"
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.currentTarget.value)}
        onKeyDown={keyDownSearchHandler}
        rightSection={
          <ActionIcon variant="subtle" onClick={submitSearch} aria-label="Search">
            <FaMagnifyingGlass />
          </ActionIcon>
        }
      />
      <Button onClick={() => setOpenCreateHeroForm(true)} leftSection={<FaPlus />}>Hero</Button>
      <HeroForm size='xs' open={openCreateHeroForm} textButton='Save' title='New Hero' handleClose={() => setOpenCreateHeroForm(false)} />
    </Group>
  )
}

export default Searcher