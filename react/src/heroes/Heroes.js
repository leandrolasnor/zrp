import { useEffect } from 'react'
import { Container } from '@mantine/core'
import { useDispatch, useSelector } from 'react-redux'
import Filter from './Filter.js'
import Searcher from './Searcher.js'
import List from './List.js'
import Paginate from './Paginate.js'
import { get_ranks } from './actions'

const Heroes = () => {
  const dispatch = useDispatch()
  const ranks = useSelector(state => state.heroes.ranks)

  useEffect(() => {
    if (ranks?.length === 0) dispatch(get_ranks())
  }, [ranks, dispatch])

  return (
    <Container fluid>
      <Filter />
      <Searcher />
      <Paginate />
      <List />
    </Container>
  )
}

export default Heroes
