import { useRef } from 'react'
import PropTypes from 'prop-types'
import { CENTER, CONTINENTS, GRATICULE, RADIUS, VIEWBOX_SIZE, project, pathFromCoordinates } from './projection'

const rankColors = {
  god: '#3b82f6',
  dragon: '#22c55e',
  tiger: '#a855f7',
  wolf: '#ef4444'
}

const Globe = ({ threats, rotation, tilt, hovered, onHover, onSelect, onRotate }) => {
  const drag = useRef(null)

  const positionOf = event => {
    const touch = event.touches?.[0]
    return { x: touch?.clientX ?? event.clientX ?? 0, y: touch?.clientY ?? event.clientY ?? 0 }
  }

  const handleDragStart = event => {
    const position = positionOf(event)
    drag.current = { ...position, rotation, tilt }
  }

  const handleDragMove = event => {
    if (!drag.current) return
    const position = positionOf(event)
    const dx = position.x - drag.current.x
    const dy = position.y - drag.current.y

    onRotate({
      rotation: drag.current.rotation - dx * 0.5,
      tilt: Math.max(-70, Math.min(70, drag.current.tilt + dy * 0.4))
    })
  }

  const handleDragEnd = () => {
    drag.current = null
  }

  return (
    <svg
      viewBox={`0 0 ${VIEWBOX_SIZE} ${VIEWBOX_SIZE}`}
      data-testid="earth-globe"
      role="img"
      aria-label="Interactive globe"
      style={{ width: '100%', height: 'auto', display: 'block', touchAction: 'none', cursor: 'grab' }}
      onMouseDown={handleDragStart}
      onMouseMove={handleDragMove}
      onMouseUp={handleDragEnd}
      onMouseLeave={handleDragEnd}
      onTouchStart={handleDragStart}
      onTouchMove={handleDragMove}
      onTouchEnd={handleDragEnd}
    >
      <defs>
        <radialGradient id="earth-surface" cx="35%" cy="30%" r="75%">
          <stop offset="0%" stopColor="#1e3a5f" />
          <stop offset="100%" stopColor="#0b1625" />
        </radialGradient>
      </defs>

      <circle cx={CENTER} cy={CENTER} r={RADIUS} fill="url(#earth-surface)" stroke="#3b82f6" strokeWidth={1.5} />

      {GRATICULE.map((coordinates, index) => (
        <path
          key={`graticule-${index}`}
          d={pathFromCoordinates(coordinates, rotation, tilt)}
          fill="none"
          stroke="#4b6a8a"
          strokeWidth={0.7}
          opacity={0.55}
        />
      ))}

      {CONTINENTS.map((coordinates, index) => (
        <path
          key={`continent-${index}`}
          d={pathFromCoordinates(coordinates, rotation, tilt)}
          fill="#1f7a5a"
          fillOpacity={0.55}
          stroke="#38b48b"
          strokeWidth={0.8}
          opacity={0.9}
        />
      ))}

      {threats.map(threat => {
        const point = project(Number(threat.lat), Number(threat.lng), rotation, tilt)
        if (!point.visible) return null

        return (
          <circle
            key={threat.id}
            cx={point.x}
            cy={point.y}
            r={hovered === threat.id ? 9 : 6}
            fill={rankColors[threat.rank] ?? '#94a3b8'}
            stroke="#fff"
            strokeWidth={1.5}
            style={{ cursor: 'pointer' }}
            data-testid={`earth-point-${threat.id}`}
            aria-label={`Threat ${threat.name}`}
            onMouseEnter={() => onHover(threat.id, point)}
            onMouseLeave={() => onHover(null, null)}
            onClick={() => onSelect(threat)}
          />
        )
      })}
    </svg>
  )
}

Globe.propTypes = {
  threats: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    name: PropTypes.string,
    rank: PropTypes.string,
    lat: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
    lng: PropTypes.oneOfType([PropTypes.number, PropTypes.string])
  })),
  rotation: PropTypes.number,
  tilt: PropTypes.number,
  hovered: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
  onHover: PropTypes.func.isRequired,
  onSelect: PropTypes.func.isRequired,
  onRotate: PropTypes.func.isRequired
}

export default Globe
