import { compose, createStore, applyMiddleware } from 'redux';

import thunkMiddleware from 'redux-thunk';

import reducer, { initialStates } from '../reducers/root-reducer';

export default props => {
  const { people, examinations, localization, examinationResults } = props;
  const { groupPerformanceState } = initialStates;

  const initialState = {
    groupPerformanceStore: {
      ...groupPerformanceState,
      people,
      examinations,
      localization,
      examinationResults,
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
