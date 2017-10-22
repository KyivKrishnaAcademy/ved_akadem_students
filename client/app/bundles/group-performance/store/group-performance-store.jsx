import { compose, createStore, applyMiddleware } from 'redux';

import thunkMiddleware from 'redux-thunk';

import reducer, { initialStates } from '../reducers/root-reducer';

function examinationResultsObj(people, examinations, examinationResults) {
  const result = {};

  examinationResults.forEach(examinationResult => {
    const examId = examinationResult.examinationId;
    const personId = examinationResult.personId;

    if (!result[examId]) result[examId] = {};

    result[examId][personId] = examinationResult;
  });

  examinations.forEach(examination => {
    if (!result[examination.id]) result[examination.id] = {};

    people.forEach(person => {
      if (!result[examination.id][person.id]) result[examination.id][person.id] = {};
    });
  });

  return result;
}

export default props => {
  const { people, examinations, localization, examinationResults } = props;
  const { groupPerformanceState } = initialStates;

  const initialState = {
    groupPerformanceStore: {
      ...groupPerformanceState,
      people,
      examinations,
      localization,
      examinationResults: examinationResultsObj(people, examinations, examinationResults),
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
