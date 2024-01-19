import { Tag, Badge } from 'rsuite'

const AverageScore = props => {
  const { score } = props

  if (score) return <Tag><Badge color="cyan" content={Number(score).toFixed(2)}>average score</Badge></Tag>
}
export default AverageScore
