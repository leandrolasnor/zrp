import React from 'react'
import { HashRouter, Routes as Switch, Route } from 'react-router-dom'
import Dashboard from './dashboard/Dashboard'
import Heroes from './heroes/Heroes'
import ErrorBoundary from './ErrorBoundary'

const routes = [
  { key: 1, exact: true, path: '/', element: <ErrorBoundary><Dashboard /></ErrorBoundary> },
  { key: 2, exact: true, path: '/heroes', element: <ErrorBoundary><Heroes /></ErrorBoundary> }
];


const Routes = () => (
  <HashRouter>
    <Switch>
      {routes.map(route => (
        <Route key={route.key} exact={route.exact} path={route.path} element={route.element} />
      ))}
    </Switch>
  </HashRouter>
);

export default Routes;
