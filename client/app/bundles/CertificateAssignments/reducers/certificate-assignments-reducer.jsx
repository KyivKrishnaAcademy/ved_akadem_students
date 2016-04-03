import actionTypes from '../constants/certificate-assignments-constants';

export const initialState = {
  name: '', // this is the default state that would be used if one were not passed into the store
};

export default function certificateAssignmentsReducer(state = initialState, action) {
  const { type, name } = action;

  switch (type) {
    case actionTypes.HELLO_WORLD_NAME_UPDATE:
      return {
        ...state,
        name,
      };

    default:
      return state;
  }
}
