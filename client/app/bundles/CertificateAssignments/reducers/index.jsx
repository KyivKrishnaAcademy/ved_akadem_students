// A real world app will likely have many reducers and it helps to organize them in one file.
import certificateAssignmentsReducer from './certificate-assignments-reducer';
import { $$initialState as $$helloWorldState } from './certificate-assignments-reducer';

export default {
  $$helloWorldStore: certificateAssignmentsReducer,
};

export const initialStates = {
  $$helloWorldState,
};
