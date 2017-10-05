import { compose, createStore, applyMiddleware } from 'redux';

// See
// https://github.com/gaearon/redux-thunk and http://redux.js.org/docs/advanced/AsyncActions.html
// This is not actually used for this simple example, but you'd probably want to use this
// once your app has asynchronous actions.
import thunkMiddleware from 'redux-thunk';

import reducer, { initialStates } from '../reducers/root-reducer';

export default props => {
  // This is how we get initial props Rails into redux.
  const { people, canManage, academicGroupId } = props;
  const { groupAttendanceState } = initialStates;

  const initialState = {
    groupAttendanceStore: {
      ...groupAttendanceState,
      people,
      canManage,
      academicGroupId,
    },
  };

  const composedStore = compose(
    applyMiddleware(thunkMiddleware),
    typeof window === 'object' && window.__REDUX_DEVTOOLS_EXTENSION__
      ? window.__REDUX_DEVTOOLS_EXTENSION__()
      : fn => fn
  );

  const storeCreator = composedStore(createStore);
  const store = storeCreator(reducer, initialState);

  return store;
};
