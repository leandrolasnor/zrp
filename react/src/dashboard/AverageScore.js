import { Tag, Badge } from 'rsuite'
import { useSelector } from 'react-redux'
import { memo } from 'react'

const AverageScore = () => {
  const average_score = useSelector(state => state.metrics.average_score)

  if (average_score) return <Tag><Badge color="cyan" content={average_score}>average score</Badge></Tag>
}
export default memo(AverageScore)
