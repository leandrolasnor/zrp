import { Badge } from '@mantine/core'
import { useSelector } from 'react-redux'
import { memo } from 'react'

const AverageScore = () => {
  const average_score = useSelector(state => state.metrics.average_score)

  if (average_score) return <Badge color="gray" variant="light">average score: {average_score}</Badge>
  return null
}
export default memo(AverageScore)
