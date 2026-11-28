import { Badge, Text, Timeline } from '@mantine/core'
import PropTypes from 'prop-types'

const heroRankColors = {
  s: 'blue',
  a: 'green',
  b: 'violet',
  c: 'red'
}

const formatDate = value => {
  if (!value) return 'time unknown'
  const date = new Date(value)
  return Number.isNaN(date.getTime()) ? String(value) : date.toLocaleString()
}

const formatDetail = value => {
  if (Array.isArray(value)) {
    return value.map(item => item?.name ?? item?.score ?? JSON.stringify(item)).join(', ') || '-'
  }
  if (value && typeof value === 'object') {
    return Object.entries(value).map(([key, item]) => `${key}: ${item}`).join(', ')
  }
  return String(value)
}

const formatDetailItem = item => {
  if (!item || typeof item !== 'object' || Array.isArray(item)) return String(item ?? '-')
  return String(item.name ?? item.score ?? JSON.stringify(item))
}

const ThreatTimeline = ({ events }) => {
  if (!events?.length) {
    return (
      <Text size="sm" c="dimmed" data-testid="threat-timeline">
        No events recorded for this threat.
      </Text>
    )
  }

  return (
    <Timeline active={events.length - 1} bulletSize={12} lineWidth={2} data-testid="threat-timeline">
      {events.map((event, index) => (
        <Timeline.Item
          key={event.id ?? `${event.type}-${index}`}
          data-testid={`threat-timeline-item-${index}`}
          title={event.title ?? event.type}
          // Linhas e pontos cinza em todos os eventos, inclusive o primeiro.
          color="gray"
        >
          <Text size="xs" c="dimmed">{formatDate(event.occurred_at)} · {event.type}</Text>
          {Array.isArray(event.details) ? (
            event.details.length === 0
              ? <Text size="xs">-</Text>
              : event.details.map((item, index) => (
                <Text key={index} component="div" size="xs" data-testid={`timeline-detail-${index}`}>
                  {item?.rank && (
                    <Badge color={heroRankColors[item.rank]} variant="light" size="xs" mr="xs">
                      {item.rank}
                    </Badge>
                  )}
                  {formatDetailItem(item)}
                </Text>
              ))
          ) : Object.entries(event.details ?? {}).map(([key, value]) => (
            <Text key={key} size="xs">
              <Text component="span" fw={600}>{key}:</Text> {formatDetail(value)}
            </Text>
          ))}
        </Timeline.Item>
      ))}
    </Timeline>
  )
}

ThreatTimeline.propTypes = {
  events: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.string,
    type: PropTypes.string,
    title: PropTypes.string,
    occurred_at: PropTypes.string,
    details: PropTypes.oneOfType([PropTypes.object, PropTypes.array])
  }))
}

export default ThreatTimeline
