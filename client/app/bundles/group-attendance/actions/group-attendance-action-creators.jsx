import actionTypes from '../constants/group-attendance-constants';

export function openAttendanceSubmitter(selectedScheduleId) {
  return {
    selectedScheduleId,
    type: actionTypes.OPEN_ATTENDANCE_SUBMITTER,
  };
}
