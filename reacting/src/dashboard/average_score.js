import { Tag, Badge } from 'rsuite'
import { useSelector } from 'react-redux'

const AverageScore = () => {
  const { average_score } = useSelector(state => state.metrics)

  if (average_score) return <Tag><Badge color="cyan" content={average_score}>average score</Badge></Tag>
}
export default AverageScore
