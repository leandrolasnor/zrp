export const rankColors = {
  s: 'cyan',
  a: 'green',
  b: 'violet',
  c: 'red'
}

export const rankColor = (rank) => rankColors[rank] || 'gray'

export const rankTextColor = (rank) => rank ? `var(--mantine-color-${rankColor(rank)}-6)` : undefined
