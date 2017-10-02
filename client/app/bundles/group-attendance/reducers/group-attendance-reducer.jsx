import actionTypes from '../constants/group-attendance-constants';

export const initialState = {
  page: 0,
  classSchedules: [],
  selectedScheduleId: null,
  selectedPersonIndex: 0,
  isAttendanceSubmitterShown: false,
};

export default function groupAttendanceReducer(state = initialState, action) {
  switch (action.type) {
    case actionTypes.OPEN_ATTENDANCE_SUBMITTER:
      return {
        ...state,
        selectedScheduleId: action.selectedScheduleId,
        isAttendanceSubmitterShown: true,
      };

    case actionTypes.UPDATE_CLASS_SCHEDULES_AND_PAGE:
      return {
        ...state,
        page: action.page,
        classSchedules: [...action.classSchedules, ...state.classSchedules],
      };

    default:
      return state;
  }
}
