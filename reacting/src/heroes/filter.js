import { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { IconButton, Accordion, Tag, Col, Row, InputPicker, Stack } from 'rsuite'
import Funnel from '@rsuite/icons/Funnel'
import { FaAngleDoubleDown } from 'react-icons/fa';
import { get_statuses, get_ranks } from './actions'

const Filter = () => {
  const [activeKey, setActiveKey] = useState(0)
  const [rankFilter, setRankFilter] = useState(false)
  const [statusFilter, setStatusFilter] = useState(false)
  const { ranks, statuses, search: { filter } } = useSelector(state => state.heroes)
  const dispatch = useDispatch()

  useEffect(() => { if (ranks?.length === 0) dispatch(get_ranks()) }, [ranks, dispatch])
  useEffect(() => { if (statuses?.length === 0) dispatch(get_statuses()) }, [statuses, dispatch])


  const colors = {
    s: 'blue',
    a: 'green',
    b: 'violet',
    c: 'red'
  }

  const ranksData = Object.entries(ranks).map(([k, v]) => ({
    label: <Tag size='sm' color={colors[k]}>{k}</Tag>,
    value: k
  }))
  const statusesData = Object.entries(statuses).map(([k, v]) => ({
    label: <Tag size='sm'>{v}</Tag>,
    value: v
  }))

  const applyFilter = () => {
    let filter = []
    if (rankFilter) filter.push(`rank = '${rankFilter}'`)
    if (statusFilter) filter.push(`status = '${statusFilter}'`)
    dispatch({ type: 'SET_FILTER', payload: filter })
  }

  const handleAccordionSelect = (key, event) => {
    setActiveKey(key)
    if (event.currentTarget.ariaExpanded === 'true') {
      setStatusFilter(false)
      setRankFilter(false)
      if (filter.length) dispatch({ type: 'CLEAR_FILTER' })
    }
  }

  return (
    <Row className='mt-3'>
      <Accordion activeKey={activeKey} onSelect={handleAccordionSelect}>
        <Accordion.Panel eventKey={1} header="Filter" caretAs={FaAngleDoubleDown} >
          <Row className='mt-2'>
            <Col md={4}>
              <InputPicker placeholder="Rank" key='rank' value={rankFilter} autoFocus data={ranksData.reverse()} onChange={setRankFilter} />
            </Col >
            <Col md={4}>
              <InputPicker placeholder="Status" key='status' value={statusFilter} data={statusesData.reverse()} onChange={setStatusFilter} />
            </Col>
            <Col md={16}>
              <Stack justifyContent="flex-end"><IconButton onClick={applyFilter} icon={<Funnel />}>Apply</IconButton></Stack>
            </Col>
          </Row>
        </Accordion.Panel>
      </Accordion>
    </Row>
  )
}

export default Filter
