import { useEffect } from 'react'
import { useDispatch } from 'react-redux'
import { useForm } from 'react-hook-form'
import { Modal, Button, Form } from 'rsuite'
import { create_hero } from './actions.js'

const HeroForm = props => {
  const dispatch = useDispatch()
  const { size, open, handleClose, textButton } = props
  const { register, handleSubmit, reset } = useForm()
  useEffect(() => { reset() }, [])


  return (
    <Form layout="horizontal" onSubmit={handleSubmit(data => dispatch([create_hero(data), reset(), handleClose()]))}>
      <Modal size={size} open={open} onClose={handleClose}>
        <Modal.Header>
          <Modal.Title>New Hero</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form.Group controlId="name-6">
            <Form.ControlLabel>Username</Form.ControlLabel>
            <Form.Control {...register('taxpayer_number')} />
            <Form.HelpText>Required</Form.HelpText>
          </Form.Group>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={handleClose} appearance="subtle">Cancel</Button>
          <Button type='submit' appearance='primary'>{textButton || 'Ok'}</Button>
        </Modal.Footer>
      </Modal>
    </Form>
  )
}


export default HeroForm
