import actionTypes from '../constants/group-attendance-constants';

export const initialState = {
  name: '', // this is the default state that would be used if one were not passed into the store
};

export default function groupAttendanceReducer(state = initialState, action) {
  const { type, name } = action;

  switch (type) {
    case actionTypes.TOGGLE_WRITEABLE:
      return {
        ...state,
        name,
      };

    default:
      return state;
  }
}
