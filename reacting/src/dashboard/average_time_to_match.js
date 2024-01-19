import { Tag, Badge } from 'rsuite'

const _ = require('lodash')

const AverageTimeToMatch = props => {
  let { data } = props
  let result = null
  let hours = _.get(data, 'hours', false)
  let minutes = _.get(data, 'minutes', false)
  let seconds = _.get(data, 'seconds', false)

  if (hours) result = `${Number(hours).toFixed(0) }h`
  if (minutes) result = `${Number(minutes).toFixed(0)}min`
  if (seconds) result = `${Number(seconds).toFixed(0) }s`

  if(result) return <Tag><Badge color="green" content={result}>avg time to match</Badge></Tag>
}

export default AverageTimeToMatch
