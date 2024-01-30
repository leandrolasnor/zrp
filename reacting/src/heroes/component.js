import { useSelector } from 'react-redux'
import { Grid } from 'rsuite'
import Searcher from './searcher.js'
import List from './list.js'
import Paginate from './paginate.js'

const Heroes = props => {
  const heroes = useSelector(state => state.heroes)
  const { search: { query } } = heroes

  return (
    <Grid>
      <Searcher query={query} />
      <Paginate heroes={heroes} />
      <List heroes={heroes} />
    </Grid>
  )
}

export default Heroes
