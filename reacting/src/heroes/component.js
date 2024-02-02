import { useSelector } from 'react-redux'
import { Grid } from 'rsuite'
import Searcher from './searcher.js'
import List from './list.js'
import Paginate from './paginate.js'

const Heroes = props => {
  const { metrics: { super_hero } } = useSelector(state => state.metrics)
  const heroes = useSelector(state => state.heroes)
  const { search: { query } } = heroes

  return (
    <Grid fluid>
      <Searcher query={query} />
      <Paginate heroes={heroes} />
      <List heroes={heroes} super_hero={super_hero} />
    </Grid>
  )
}

export default Heroes
