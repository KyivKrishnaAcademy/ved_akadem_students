import $ from 'jquery'; // eslint-disable-line id-length
import actionTypes from '../constants/group-attendance-constants';

export function openAttendanceSubmitter(selectedScheduleId) {
  $('#attendanceSubmitterModal').modal('show');

  return {
    selectedScheduleId,
    type: actionTypes.OPEN_ATTENDANCE_SUBMITTER,
  };
}
