import { compose, createStore, applyMiddleware } from 'redux';

// See
// https://github.com/gaearon/redux-thunk and http://redux.js.org/docs/advanced/AsyncActions.html
// This is not actually used for this simple example, but you'd probably want to use this
// once your app has asynchronous actions.
import thunkMiddleware from 'redux-thunk';

import reducer, { initialStates } from '../reducers/root-reducer';

export default props => {
  // This is how we get initial props Rails into redux.
  const { name } = props;
  const { $$helloWorldState } = initialStates;

  // Redux expects to initialize the store using an Object, not an Immutable.Map
  const initialState = {
    $$helloWorldStore: $$helloWorldState.merge({
      name,
    }),
  };

  const composedStore = compose(
    applyMiddleware(thunkMiddleware),
    typeof window !== 'undefined' && window.devToolsExtension ? window.devToolsExtension() : f => f
  );
  const storeCreator = composedStore(createStore);
  const store = storeCreator(reducer, initialState);

  return store;
};
