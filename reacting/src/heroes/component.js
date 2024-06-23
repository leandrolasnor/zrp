import { Grid } from 'rsuite'
import Searcher from './searcher.js'
import List from './list.js'
import Paginate from './paginate.js'

const Heroes = () => {

  return (
    <Grid fluid>
      <Searcher />
      <Paginate />
      <List />
    </Grid>
  )
}

export default Heroes
