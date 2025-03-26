import { useEffect, useState } from 'react'
import { useDispatch } from 'react-redux'
import { Slider } from 'rsuite'
import { set_insurgency } from '../dashboard/actions.js'

const InsurgencySlider = () => {
  const dispatch = useDispatch()
  const data = { '1s': 1, '5s': 5, '10s': 10, '20s': 20 }
  const [insurgency, setInsurgency] = useState(Object.keys(data).length - 1)
  useEffect(() => dispatch(set_insurgency(Object.values(data)[insurgency])), [insurgency])
  return (
    <Slider
      progress
      graduated
      min={0}
      max={Object.keys(data).length - 1}
      style={{ width: 100 }}
      value={insurgency}
      onChange={setInsurgency}
      renderMark={i => Object.keys(data)[i]}
    />
  )
}

export default InsurgencySlider
