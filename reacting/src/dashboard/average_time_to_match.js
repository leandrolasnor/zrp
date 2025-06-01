import { Tag, Badge } from 'rsuite'
import { useSelector } from 'react-redux'

const AverageTimeToMatch = () => {
  const { average_time_to_match: { hours, minutes, seconds } } = useSelector(state => state.metrics)

  let result = ''
  if (hours) result = `${Number(hours).toFixed(0)}h`
  if (minutes) result = `${result}${Number(minutes).toFixed(0)}min`
  if (seconds) result = `${result}${Number(seconds).toFixed(0)}s`

  if (result) return <Tag><Badge color="green" content={result}>avg time to match</Badge></Tag>
}

export default AverageTimeToMatch
