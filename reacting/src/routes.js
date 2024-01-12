import React from 'react'
import { HashRouter, Routes as Switch, Route } from 'react-router-dom'
import Dashboard from './dashboard/component'

const routes = [
  { key: 1, exact: true, index: true,  path: '/', element: <Dashboard/> }
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
