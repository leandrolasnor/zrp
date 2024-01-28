import { Row, Col, Grid } from 'rsuite'
import Searcher from './searcher.js'
import List from './list.js'
import Paginate from './paginate.js'

const Heroes = props => {
  return (
    <>
      <Row><Col xs={24}><Searcher /></Col></Row>
      <Row><Col sm={24}><List /></Col></Row>
      <Row><Col sm={24}><Paginate /></Col></Row>
    </>
  )
}

export default Heroes
