import actionTypes from '../constants/group-attendance-constants';

export const initialState = {
  page: 0,
  classSchedules: [],
  selectedScheduleId: null,
  selectedPersonIndex: 0,
};

export default function groupAttendanceReducer(state = initialState, action) {
  switch (action.type) {
    case actionTypes.OPEN_ATTENDANCE_SUBMITTER:
      return {
        ...state,
        selectedScheduleId: action.selectedScheduleId,
        selectedPersonIndex: 0,
      };

    case actionTypes.PREVIOUS_PERSON:
      return {
        ...state,
        selectedPersonIndex: state.selectedPersonIndex > 0 ? state.selectedPersonIndex - 1 : 0,
      };

    case actionTypes.NEXT_PERSON:
      return {
        ...state,
        selectedPersonIndex: state.selectedPersonIndex < (state.people.length - 1)
          ? state.selectedPersonIndex + 1
          : state.selectedPersonIndex,
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
