import { Grid } from 'rsuite'
import Filter from './Filter.js'
import Searcher from './Searcher.js'
import List from './List.js'
import Paginate from './Paginate.js'

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
