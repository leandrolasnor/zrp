import { Grid } from 'rsuite'
import Filter from './filter.js'
import Searcher from './searcher.js'
import List from './list.js'
import Paginate from './paginate.js'

const Heroes = () => {

  return (
    <Grid fluid>
      <Filter />
      <Searcher />
      <Paginate />
      <List />
    </Grid>
  )
}

export default Heroes
