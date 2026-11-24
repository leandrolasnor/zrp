import { useEffect, useState } from 'react'
import { useDispatch } from 'react-redux'
import { Slider } from '@mantine/core'
import { set_insurgency } from '../dashboard/actions.js'

const InsurgencySlider = () => {
  const dispatch = useDispatch()
  const data = { '5s': 5, '10s': 10, '20s': 20 }
  const [insurgency, setInsurgency] = useState(Object.keys(data).length - 1)
  useEffect(() => {
    const timer = setTimeout(() => dispatch(set_insurgency(Object.values(data)[insurgency])), 1000)
    return () => clearTimeout(timer)
  }, [insurgency])
  const marks = Object.keys(data).map((k, i) => ({ value: i, label: k }))
  return (
    <Slider
      min={0}
      max={Object.keys(data).length - 1}
      step={1}
      value={insurgency}
      onChange={setInsurgency}
      marks={marks}
      style={{ width: 140 }}
    />
  )
}

export default InsurgencySlider
