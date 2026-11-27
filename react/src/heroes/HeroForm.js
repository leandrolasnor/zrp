import { useState, useEffect, useMemo } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Modal, Button, TextInput, Select, Group, Badge } from '@mantine/core'
import { create_hero, update_hero } from './actions.js'
import { rankColor, rankTextColor } from './rankColors.js'
import _ from 'lodash'
import PropTypes from 'prop-types'

const HeroForm = props => {
  const { size, open, handleClose, textButton, title, data } = props
  const dispatch = useDispatch()
  const { ranks } = useSelector(state => state.heroes)
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
  const [errors, setErrors] = useState({})

  const close = () => {
    setFormValue({ name: '', rank: '', lat: '', lng: '' })
    setErrors({})
    handleClose()
  }
  const handleSubmit = () => {
    const newErrors = {}
    if (!formValue.name) newErrors.name = 'This field is required.'
    if (!formValue.rank) newErrors.rank = 'This field is required.'
    if (!formValue.lat) newErrors.lat = 'This field is required.'
    if (!formValue.lng) newErrors.lng = 'This field is required.'
    setErrors(newErrors)
    if (Object.keys(newErrors).length > 0) return
    const action = _.get(data, 'id', false) ? update_hero(formValue) : create_hero(formValue)
    dispatch(action).then(close).catch(() => { })
  }
  const selectData = useMemo(() =>
    ranks.map((rank) => ({
      label: rank.toUpperCase(),
      value: rank
    })).reverse(),
    [ranks]
  )

  useEffect(() => { setFormValue(INITIAL_VALUES); setErrors({}) }, [data])

  return (
    <Modal opened={open} onClose={close} title={title} size={size || 'md'}>
      <TextInput
        label="Name"
        value={formValue.name || ''}
        onChange={(e) => setFormValue({ ...formValue, name: e.currentTarget.value })}
        error={errors.name}
        mb="sm"
      />
      <Select
        label="Rank"
        data={selectData}
        value={formValue.rank || null}
        onChange={(val) => setFormValue({ ...formValue, rank: val || '' })}
        error={errors.rank}
        mb="sm"
        clearable
        styles={{ input: { color: rankTextColor(formValue.rank), fontWeight: 700 } }}
        renderOption={({ option }) => (
          <Badge color={rankColor(option.value)} variant="light">{option.value.toUpperCase()}</Badge>
        )}
      />
      <TextInput
        label="Latitude"
        value={formValue.lat || ''}
        onChange={(e) => setFormValue({ ...formValue, lat: e.currentTarget.value })}
        error={errors.lat}
        mb="sm"
      />
      <TextInput
        label="Longitude"
        value={formValue.lng || ''}
        onChange={(e) => setFormValue({ ...formValue, lng: e.currentTarget.value })}
        error={errors.lng}
        mb="sm"
      />
      <Group justify="flex-end" mt="md">
        <Button variant="subtle" onClick={close}>Cancel</Button>
        <Button onClick={handleSubmit}>{textButton || 'Ok'}</Button>
      </Group>
    </Modal>
  )
}

HeroForm.propTypes = {
  size: PropTypes.string,
  open: PropTypes.bool.isRequired,
  handleClose: PropTypes.func.isRequired,
  textButton: PropTypes.string,
  title: PropTypes.string,
  data: PropTypes.object,
}

export default HeroForm
