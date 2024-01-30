import { useRef, useState, forwardRef } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Modal, Button, Schema, Form, InputPicker } from 'rsuite'
import { create_hero, get_ranks } from './actions.js'

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
  rank: Schema.Types.NumberType().isRequired('This field is required.'),
  lat: Schema.Types.StringType().isRequired('This field is required.'),
  lng: Schema.Types.StringType().isRequired('This field is required.')
})

const HeroForm = props => {
  const { size, open, handleClose, textButton } = props
  const dispatch = useDispatch()
  const { ranks } = useSelector(state => state.heroes)
  const formRef = useRef()
  const [formError, setFormError] = useState({})

  const INITIAL_VALUES = {
    name: '',
    rank: '',
    lat: '',
    lng: ''
  }
  const [formValue, setFormValue] = useState(INITIAL_VALUES)

  const handleSubmit = () => {
    if (formRef.current.check()) dispatch([create_hero(formValue), close()])
  }

  const close = () => {
    setFormValue(INITIAL_VALUES)
    handleClose()
  }

  const selectData = Object.entries(ranks).map(([k, v]) => ({
    label: k,
    value: v
  }))

  const handleRankSelect = () => ranks?.length === 0 ? dispatch(get_ranks()) : null

  return (
    <Form
      layout="horizontal"
      ref={formRef}
      onChange={setFormValue}
      onCheck={setFormError}
      formValue={formValue}
      model={model}
    >
      <Modal size={size} open={open} onClose={close}>
        <Modal.Header>
          <Modal.Title>New Hero</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <TextField name='name' label="Name" />
          <TextField name='rank' onClick={() => handleRankSelect()} label="Rank" accepter={InputPicker} data={selectData} />
          <TextField name='lat' label="Lat" />
          <TextField name='lng' label="Lng" />
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
