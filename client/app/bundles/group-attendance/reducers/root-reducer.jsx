// A real world app will likely have many reducers and it helps to organize them in one file.
import groupAttendanceReducer from './group-attendance-reducer';
import { initialState as groupAttendanceState } from './group-attendance-reducer';
import { combineReducers } from 'redux';

export const initialStates = {
  groupAttendanceState,
};

const reducer = combineReducers({
  groupAttendanceStore: groupAttendanceReducer,
});

export default reducer;
