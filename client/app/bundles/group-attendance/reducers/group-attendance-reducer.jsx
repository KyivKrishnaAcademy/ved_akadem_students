import actionTypes from '../constants/group-attendance-constants';

export const initialState = {
  selectedScheduleId: null,
  isAttendanceSubmitterShown: false,
};

export default function groupAttendanceReducer(state = initialState, action) {
  const { type, selectedScheduleId } = action;

  switch (type) {
    case actionTypes.OPEN_ATTENDANCE_SUBMITTER:
      return {
        ...state,
        selectedScheduleId,
        isAttendanceSubmitterShown: true,
      };

    default:
      return state;
  }
}
