import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useDispatch } from 'react-redux'
import {sign_in, sign_up} from './actions'
import {
  Button,
  Offcanvas,
  Container,
  Row,
  Col,
  Form,
  FloatingLabel
} from 'react-bootstrap'

export default function Auth() {
  const {register, handleSubmit, reset} = useForm()
  const dispatch = useDispatch()

  const [showStart, setShowStart] = useState(false)
  const [showEnd, setShowEnd] = useState(false)

  const handleCloseStart = () => setShowStart(false)
  const handleShowStart = () => setShowStart(true)
  const handleCloseEnd = () => setShowEnd(false)
  const handleShowEnd = () => setShowEnd(true)

  return (
    <Container>
      <Row>
        <Col className='mt-2 justify-content-end' md={{span: 2, offset: 4}} sm={12}>
          <Button className='w-100' onClick={handleShowStart}>Sign In</Button>

          <Offcanvas show={showStart} onHide={handleCloseStart} placement='start' key='start'>
            <Offcanvas.Header closeButton>
              <Offcanvas.Title>Sign In</Offcanvas.Title>
            </Offcanvas.Header>
            <Offcanvas.Body>
              <Form onSubmit={handleSubmit(data => dispatch([sign_in(data), reset()]))}>
                <Form.Group>
                  <Col lg={12}>
                    <FloatingLabel label="E-mail">
                      <Form.Control placeholder="E-mail" type="email" {...register('email')} />
                    </FloatingLabel>
                  </Col>
                  <Col lg={12} className='mt-2'>
                    <FloatingLabel label="Password">
                      <Form.Control placeholder="Password" type='password' {...register('password')} />
                    </FloatingLabel>
                  </Col>
                  <Col className='mt-2' lg={6} md={12} sm={12} xs={12}>
                    <Button variant="success" type="submit">Sign In</Button>
                  </Col>
                </Form.Group>
              </Form>
            </Offcanvas.Body>
          </Offcanvas>
        </Col>
        <Col className='mt-2' md={{span: 2, offset: 0}} sm={12}>
          <Button className='w-100' onClick={handleShowEnd}>Sign Up</Button>

          <Offcanvas show={showEnd} onHide={handleCloseEnd} key='end' placement='end'>
            <Offcanvas.Header closeButton>
              <Offcanvas.Title>Sign Up</Offcanvas.Title>
            </Offcanvas.Header>
            <Offcanvas.Body>
              <Form onSubmit={handleSubmit(data => dispatch([sign_up(data), reset()]))}>
                <Form.Group>
                  <Col>
                    <FloatingLabel label="E-mail">
                      <Form.Control placeholder="E-mail" type="email" {...register('email')} />
                    </FloatingLabel>
                  </Col>
                  <Col className='mt-2'>
                    <FloatingLabel label="Password">
                      <Form.Control placeholder="Password" type='password' {...register('password')} />
                    </FloatingLabel>
                  </Col>
                  <Col className='mt-2'>
                    <FloatingLabel label="Confirm Password">
                      <Form.Control placeholder="Confirm Password" type='password' {...register('password_confirmation')} />
                    </FloatingLabel>
                  </Col>
                  <Col className='mt-2' lg={6} md={12} sm={12} xs={12}>
                    <Button variant="success" type="submit">Sign Up</Button>
                  </Col>
                </Form.Group>
              </Form>
            </Offcanvas.Body>
          </Offcanvas>
        </Col>
      </Row>
    </Container>
  )
}
