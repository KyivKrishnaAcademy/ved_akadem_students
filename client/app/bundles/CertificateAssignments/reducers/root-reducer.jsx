// A real world app will likely have many reducers and it helps to organize them in one file.
import certificateAssignmentsReducer from './certificate-assignments-reducer';
import { initialState as certificateAssigmentsState } from './certificate-assignments-reducer';
import { combineReducers } from 'redux';

export const initialStates = {
  certificateAssigmentsState,
};

const reducer = combineReducers({
  certificateAssignmentsStore: certificateAssignmentsReducer,
});

export default reducer;
