import { random } from "supervillains"
import _ from "lodash"

// O server é a única fonte de variação das ocorrências:
// - bem formatada       -> segue o fluxo normal
// - malformed_json      -> JSON corrompido -> un.parser.error
// - field_name_error    -> JSON válido, chaves erradas -> un.retry -> un.dead
// - data_type_error     -> JSON válido, tipos errados  -> un.retry -> un.dead
export const FAULT_KINDS = Object.freeze([
  "malformed_json",
  "field_name_error",
  "data_type_error"
])

const DEFAULT_FAULT_RATE = 0.15

export const faultRateFromEnv = (value = process.env.FAULT_RATE) => {
  const parsed = Number(value ?? DEFAULT_FAULT_RATE)

  return Number.isFinite(parsed) ? Math.min(1, Math.max(0, parsed)) : DEFAULT_FAULT_RATE
}

export const occurrence = () => ({
  location: {
    lat: Math.random() * (90 + 90) - 90,
    lng: Math.random() * (180 + 180) - 180
  },
  dangerLevel: _.sample(["God", "Dragon", "Tiger", "Wolf"]),
  monsterName: random()
})

export const faultyOccurrence = (fault, base = occurrence()) => {
  switch (fault) {
    case "field_name_error": {
      const { monsterName, dangerLevel, location, ...rest } = base
      return {
        ...rest,
        monster_name: monsterName,
        danger_level: dangerLevel,
        loc: location
      }
    }
    case "data_type_error":
      return {
        ...base,
        monsterName: 123,
        dangerLevel: 3,
        location: { lat: "invalid", lng: "invalid" }
      }
    default:
      return base
  }
}

export const serializeOccurrence = (value, fault) => {
  const json = JSON.stringify(value)

  return fault === "malformed_json" ? json.replace(/\}\s*$/, "") : json
}

// O server já entrega a mensagem serializada: o client apenas repassa ao RabbitMQ.
// `random` é injetável para tornar a seleção determinística nos testes.
export const randomPayload = ({ random = Math.random, faultRate = faultRateFromEnv() } = {}) => {
  if (random() >= faultRate) return serializeOccurrence(occurrence())

  const fault = FAULT_KINDS[Math.floor(random() * FAULT_KINDS.length) % FAULT_KINDS.length]
  return serializeOccurrence(faultyOccurrence(fault), fault)
}
