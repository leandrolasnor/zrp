const INITIAL_STATE = {
  user: JSON.parse(localStorage.getItem(process.env.REACT_APP_APPLICATION_NAME)) || null,
  validToken: false
};

var _ = require('lodash');

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case "TOKEN_VALIDATED":
      if (action.payload) {
        return { ...state, validToken: action.payload};
      }
      localStorage.removeItem(process.env.REACT_APP_APPLICATION_NAME);
      return INITIAL_STATE;
    case "LOGOUT":
      localStorage.removeItem(process.env.REACT_APP_APPLICATION_NAME);
      return INITIAL_STATE
    case "USER_FETCHED":
      localStorage.removeItem(process.env.REACT_APP_APPLICATION_NAME);
      localStorage.setItem(
        process.env.REACT_APP_APPLICATION_NAME,
        JSON.stringify({
          email: action.payload.data.email,
          uid: _.get(action.payload,"headers.uid"),
          client: _.get(action.payload,"headers.client"),
          access_token: _.get(action.payload,"headers.access_token"),
          authorization: _.get(action.payload, "headers.authorization")
        })
      );
      return {
        ...state,
        user: JSON.parse(localStorage.getItem(process.env.REACT_APP_APPLICATION_NAME)),
        validToken: true
      };
    default:
      return state;
  }
};

export default reducer;
