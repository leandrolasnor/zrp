import React from 'react'
import { HashRouter, Routes as Switch, Route } from 'react-router-dom'
import Dashboard from './dashboard/component'
import Heroes from './heroes/component'

const routes = [
  { key: 1, exact: true, index: true,  path: '/', element: <Dashboard/> },
  { key: 1, exact: true,  path: '/heroes', element: <Heroes/> }
];


const Routes = () => (
  <HashRouter>
    <Switch>
      {routes.map(todo => (
        <Route {...todo} />
      ))}
    </Switch>
  </HashRouter>
);

export default Routes;
