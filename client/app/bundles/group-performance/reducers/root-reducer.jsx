// A real world app will likely have many reducers and it helps to organize them in one file.
import groupPerformanceReducer from './group-performance-reducer';
import { initialState as groupPerformanceState } from './group-performance-reducer';
import { combineReducers } from 'redux';

export const initialStates = {
  groupPerformanceState,
};

const reducer = combineReducers({
  groupPerformanceStore: groupPerformanceReducer,
});

export default reducer;
