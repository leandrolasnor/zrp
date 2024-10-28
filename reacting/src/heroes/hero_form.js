import { useRef, useState, forwardRef, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Modal, Button, Schema, Form, InputPicker, Tag } from 'rsuite'
import { create_hero, get_ranks, update_hero } from './actions.js'

const _ = require('lodash')

const TextField = forwardRef((props, ref) => {
  const { name, label, accepter, ...rest } = props;
  return (
    <Form.Group ref={ref}>
      <Form.ControlLabel>{label} </Form.ControlLabel>
      <Form.Control name={name} accepter={accepter} {...rest} />
    </Form.Group>
  )
})

const model = Schema.Model({
  name: Schema.Types.StringType().isRequired('This field is required.'),
  rank: Schema.Types.StringType().isRequired('This field is required.'),
  lat: Schema.Types.StringType().isRequired('This field is required.'),
  lng: Schema.Types.StringType().isRequired('This field is required.')
})

const HeroForm = props => {
  const { size, open, handleClose, textButton, title, data } = props
  const dispatch = useDispatch()
  const { ranks } = useSelector(state => state.heroes)
  const formRef = useRef()
  const INITIAL_VALUES = () => {
    const values = {
      name: _.get(data, 'name', ''),
      rank: _.get(data, 'rank', ''),
      lat: _.get(data, 'lat', ''),
      lng: _.get(data, 'lng', '')
    }
    if (_.get(data, 'id', false)) values.id = data.id
    return values
  }
  const [formValue, setFormValue] = useState(INITIAL_VALUES)
  const close = () => {
    setFormValue({})
    handleClose()
  }
  const handleSubmit = () => {
    if (formRef.current.check()) _.get(data, 'id', false) ? dispatch([update_hero(formValue), close()]) : dispatch([create_hero(formValue), close()])
  }
  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }
  const selectData = ranks.map((rank) => ({
    label: <Tag size='sm' color={colors[rank]}>{rank}</Tag>,
    value: rank
  }))

  useEffect(() => { if (ranks?.length === 0) dispatch(get_ranks()) }, [ranks, dispatch])
  useEffect(() => { setFormValue(INITIAL_VALUES) }, [data])

  return (
    <Form
      layout="horizontal"
      ref={formRef}
      onChange={setFormValue}
      formValue={formValue}
      model={model}
    >
      <Modal autoFocus size={size} open={open} onClose={close}>
        <Modal.Header>
          <Modal.Title>{title}</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <TextField autoFocus name='name' label="Name" />
          <TextField name='rank' label="Rank" accepter={InputPicker} data={selectData.reverse()} />
          <TextField name='lat' label="Latitude" />
          <TextField name='lng' label="Longitude" />
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={close} appearance="subtle">Cancel</Button>
          <Button onClick={handleSubmit} appearance='primary'>{textButton || 'Ok'}</Button>
        </Modal.Footer>
      </Modal>
    </Form>
  )
}

export default HeroForm
