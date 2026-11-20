export const createLogger = (logger = console, intervalMs = 60000) => {
  const last = new Map()

  const throttled = (level, message) => {
    const now = Date.now()
    const previous = last.has(level) ? last.get(level) : -Infinity
    if (now - previous < intervalMs) return
    last.set(level, now)
    logger[level]?.(message)
  }

  return {
    log: message => throttled("log", message),
    warn: message => throttled("warn", message),
    error: message => throttled("error", message)
  }
}
