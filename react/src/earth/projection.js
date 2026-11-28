export const VIEWBOX_SIZE = 600
export const RADIUS = 240
export const CENTER = VIEWBOX_SIZE / 2

const DEG = Math.PI / 180

// Orthographic projection: only the points in the visible hemisphere are kept.
export const project = (lat, lng, rotation = 0, tilt = 0) => {
  const phi = lat * DEG
  const lambda = (lng - rotation) * DEG
  const phi0 = tilt * DEG
  const cosLat = Math.cos(phi)
  const cosAngle = Math.sin(phi0) * Math.sin(phi) +
    Math.cos(phi0) * cosLat * Math.cos(lambda)

  return {
    x: CENTER + RADIUS * cosLat * Math.sin(lambda),
    y: CENTER - RADIUS * (Math.cos(phi0) * Math.sin(phi) - Math.sin(phi0) * cosLat * Math.cos(lambda)),
    visible: cosAngle >= 0
  }
}

export const pathFromCoordinates = (coordinates, rotation, tilt) => {
  let path = ''
  let penDown = false

  coordinates.forEach(([lng, lat]) => {
    const point = project(lat, lng, rotation, tilt)
    if (!point.visible) {
      penDown = false
      return
    }
    path += `${penDown ? ' L' : ' M'}${point.x.toFixed(1)} ${point.y.toFixed(1)}`
    penDown = true
  })

  return path
}

const graticule = () => {
  const lines = []

  for (let lng = -180; lng < 180; lng += 30) {
    const line = []
    for (let lat = -90; lat <= 90; lat += 5) line.push([lng, lat])
    lines.push(line)
  }

  for (let lat = -60; lat <= 60; lat += 30) {
    const line = []
    for (let lng = -180; lng <= 180; lng += 5) line.push([lng, lat])
    lines.push(line)
  }

  return lines
}

export const GRATICULE = graticule()

// Rough outlines, enough to give the globe a recognizable silhouette.
export const CONTINENTS = [
  [[-168, 66], [-160, 71], [-140, 70], [-125, 60], [-130, 50], [-125, 40], [-117, 32],
    [-105, 25], [-97, 18], [-90, 21], [-83, 25], [-80, 30], [-75, 35], [-70, 44],
    [-60, 47], [-55, 52], [-65, 60], [-80, 63], [-95, 70], [-120, 72], [-150, 70]],
  [[-81, 8], [-75, 10], [-60, 10], [-50, 5], [-35, -5], [-38, -15], [-48, -25],
    [-53, -35], [-65, -55], [-72, -50], [-75, -35], [-80, -15], [-81, 0]],
  [[-10, 36], [-5, 43], [0, 48], [10, 54], [20, 55], [30, 60], [40, 65], [30, 70],
    [20, 70], [10, 60], [0, 58], [-10, 50]],
  [[-17, 35], [10, 37], [30, 32], [35, 22], [43, 12], [51, 12], [42, -10], [35, -25],
    [25, -34], [18, -35], [12, -20], [5, -5], [-8, 5], [-17, 15]],
  [[30, 70], [60, 75], [90, 75], [120, 72], [150, 65], [170, 60], [160, 50], [140, 45],
    [130, 35], [122, 25], [110, 20], [100, 10], [105, 0], [95, 5], [80, 8], [70, 20],
    [60, 25], [50, 30], [40, 35], [35, 45], [45, 55], [30, 60]],
  [[113, -22], [122, -18], [135, -12], [145, -16], [153, -28], [150, -38], [140, -38],
    [130, -35], [115, -34]]
]
