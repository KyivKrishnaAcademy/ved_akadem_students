import actionTypes from '../constants/group-attendance-constants';

export const initialState = {
  page: 0,
  loading: false,
  classSchedules: [],
  selectedScheduleIndex: undefined,
  selectedPersonIndex: 0,
};

function markUnknown(state, attendance) {
  const { scheduleId, studentProfileId } = attendance;

  const classSchedules = state.classSchedules.map(schedule => {
    const newSchedule = { ...schedule };

    if (newSchedule.id === scheduleId) delete newSchedule.attendances[studentProfileId];

    return newSchedule;
  });

  return {
    ...state,
    classSchedules,
  };
}

function markPresence(state, attendance) {
  const { scheduleId, studentProfileId } = attendance;

  const classSchedules = state.classSchedules.map(schedule => {
    const newSchedule = { ...schedule };

    if (newSchedule.id === scheduleId) newSchedule.attendances[studentProfileId] = attendance;

    return newSchedule;
  });

  return {
    ...state,
    classSchedules,
  };
}

export default function groupAttendanceReducer(state = initialState, action) {
  switch (action.type) {
    case actionTypes.OPEN_ATTENDANCE_SUBMITTER:
      return {
        ...state,
        selectedScheduleIndex: action.selectedScheduleIndex,
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

    case actionTypes.SHOW_LOADER:
      return {
        ...state,
        loading: true,
      };

    case actionTypes.HIDE_LOADER:
      return {
        ...state,
        loading: false,
      };

    case actionTypes.MARK_UNKNOWN:
      return action.attendance.toDelete
        ? markPresence(state, action.attendance)
        : markUnknown(state, action.attendance);

    case actionTypes.MARK_PRESENCE:
      return markPresence(state, action.attendance);

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
