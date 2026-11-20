import { appendFileSync, existsSync, mkdirSync, renameSync, statSync } from "node:fs"
import { dirname } from "node:path"
import { fileURLToPath } from "node:url"

const DEFAULT_LOG_FILE = fileURLToPath(new URL("../../log/socket-io-server.log", import.meta.url))
const MAX_SIZE = 2 * 1024 * 1024
const MAX_FILES = 5

// O serviço roda sem terminal: todos os níveis são persistidos em arquivo.
// Caminho resolvido a partir deste módulo para não depender do cwd do yarn workspace.
export const createFileLogger = ({
  filePath = DEFAULT_LOG_FILE,
  maxSize = MAX_SIZE,
  maxFiles = MAX_FILES
} = {}) => {
  mkdirSync(dirname(filePath), { recursive: true })

  const rotate = () => {
    if (!existsSync(filePath) || statSync(filePath).size < maxSize) return

    for (let index = maxFiles - 1; index >= 1; index--) {
      const source = index === 1 ? filePath : `${filePath}.${index - 1}`
      if (existsSync(source)) renameSync(source, `${filePath}.${index}`)
    }
  }

  const write = level => message => {
    try {
      rotate()
      appendFileSync(filePath, `${new Date().toISOString()} ${level} ${message}\n`)
    } catch {
      // Não há terminal para reportar a falha, e ela não pode derrubar o serviço.
    }
  }

  return {
    log: write("INFO"),
    warn: write("WARN"),
    error: write("ERROR")
  }
}
