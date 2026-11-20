import test from "node:test"
import assert from "node:assert/strict"
import {
  FAULT_KINDS,
  faultRateFromEnv,
  faultyOccurrence,
  occurrence,
  randomPayload,
  serializeOccurrence
} from "../occurrence.js"

const base = () => ({
  location: { lat: 1, lng: 2 },
  dangerLevel: "God",
  monsterName: "Joker"
})

test("occurrence keeps the original payload shape", () => {
  const value = occurrence()

  assert.deepEqual(Object.keys(value).sort(), ["dangerLevel", "location", "monsterName"])
  assert.ok(["God", "Dragon", "Tiger", "Wolf"].includes(value.dangerLevel))
  assert.ok(value.location.lat >= -90 && value.location.lat <= 90)
  assert.ok(value.location.lng >= -180 && value.location.lng <= 180)
  assert.equal(typeof value.monsterName, "string")
})

test("randomPayload returns a well-formed JSON above the fault rate", () => {
  const payload = randomPayload({ random: () => 0.9, faultRate: 0.5 })
  const value = JSON.parse(payload)

  assert.ok(value.monsterName)
  assert.ok(["God", "Dragon", "Tiger", "Wolf"].includes(value.dangerLevel))
  assert.deepEqual(Object.keys(value).sort(), ["dangerLevel", "location", "monsterName"])
})

test("randomPayload produces every fault kind", () => {
  FAULT_KINDS.forEach((fault, index) => {
    const rolls = [0, (index + 0.5) / FAULT_KINDS.length]
    let call = 0
    const payload = randomPayload({ random: () => rolls[call++], faultRate: 0.5 })

    if (fault === "malformed_json") {
      assert.throws(() => JSON.parse(payload))
      return
    }

    const value = JSON.parse(payload)

    if (fault === "field_name_error") {
      assert.deepEqual(Object.keys(value).sort(), ["danger_level", "loc", "monster_name"])
    }
    if (fault === "data_type_error") {
      assert.equal(typeof value.monsterName, "number")
      assert.equal(typeof value.dangerLevel, "number")
      assert.equal(typeof value.location.lat, "string")
      assert.equal(typeof value.location.lng, "string")
    }
  })
})

test("serializeOccurrence corrupts the JSON only for malformed_json", () => {
  const json = serializeOccurrence(base())

  assert.deepEqual(JSON.parse(json), base())
  assert.throws(() => JSON.parse(serializeOccurrence(base(), "malformed_json")))
})

test("faultRateFromEnv clamps and defaults", () => {
  assert.equal(faultRateFromEnv("0.25"), 0.25)
  assert.equal(faultRateFromEnv("-1"), 0)
  assert.equal(faultRateFromEnv("2"), 1)
  assert.equal(faultRateFromEnv("abc"), 0.15)
  assert.equal(faultRateFromEnv(undefined), 0.15)
})

test("faultyOccurrence builds each error scenario from a fixed base", () => {
  assert.deepEqual(faultyOccurrence("field_name_error", base()), {
    monster_name: "Joker",
    danger_level: "God",
    loc: { lat: 1, lng: 2 }
  })
  assert.deepEqual(faultyOccurrence("data_type_error", base()), {
    monsterName: 123,
    dangerLevel: 3,
    location: { lat: "invalid", lng: "invalid" }
  })
  assert.deepEqual(faultyOccurrence("unknown", base()), base())
})
