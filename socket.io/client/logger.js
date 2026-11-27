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
    // Payloads não são throttled: o log precisa refletir tudo o que o client recebe.
    log: message => logger.log?.(message),
    warn: message => throttled("warn", message),
    error: message => throttled("error", message)
  }
}
