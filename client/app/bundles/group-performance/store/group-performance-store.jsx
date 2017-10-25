import { compose, createStore, applyMiddleware } from 'redux';

import thunkMiddleware from 'redux-thunk';

import reducer, { initialStates } from '../reducers/root-reducer';

function examinationResultsObj(people, examinations, examinationResults) {
  const result = {};

  examinationResults.forEach(examinationResult => {
    const examId = examinationResult.examinationId;
    const studentProfileId = examinationResult.studentProfileId;

    if (!result[examId]) result[examId] = {};

    result[examId][studentProfileId] = examinationResult;
  });

  examinations.forEach(examination => {
    if (!result[examination.id]) result[examination.id] = {};

    people.forEach(person => {
      if (!result[examination.id][person.studentProfileId]) result[examination.id][person.studentProfileId] = {};
    });
  });

  return result;
}

export default props => {
  const { people, canManage, examinations, localization, examinationResults } = props;
  const { groupPerformanceState } = initialStates;

  const initialState = {
    groupPerformanceStore: {
      ...groupPerformanceState,
      people,
      canManage,
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
