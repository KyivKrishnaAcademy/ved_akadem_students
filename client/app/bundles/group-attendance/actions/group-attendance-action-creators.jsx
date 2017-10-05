import $ from 'jquery'; // eslint-disable-line id-length
import actionTypes from '../constants/group-attendance-constants';

export function openAttendanceSubmitter(selectedScheduleIndex) {
  $('#attendanceSubmitterModal').modal('show');

  return {
    selectedScheduleIndex,
    type: actionTypes.OPEN_ATTENDANCE_SUBMITTER,
  };
}

export function updateClassSchedulesAndPage(classSchedules, page) {
  return {
    page,
    classSchedules,
    type: actionTypes.UPDATE_CLASS_SCHEDULES_AND_PAGE,
  };
}

export function nextPerson() {
  return {
    type: actionTypes.NEXT_PERSON,
  };
}

export function previousPerson() {
  return {
    type: actionTypes.PREVIOUS_PERSON,
  };
}

function deleteAttendance(attendanceId, success, error) {
  $.ajax({
    error,
    success,
    url: `/ui/schedule_attendances/${attendanceId}`,
    cache: false,
    method: 'DELETE',
    dataType: 'json',
  });
}

function updateAttendance(attendanceId, presence, success, error) {
  $.ajax({
    error,
    success,
    url: `/ui/schedule_attendances/${attendanceId}?presence=${presence}`,
    cache: false,
    method: 'PUT',
    dataType: 'json',
  });
}

function createAttendance(personId, scheduleId, presence, success, error) {
  $.ajax({
    error,
    success,
    url: `/ui/schedule_attendances?class_schedule_id=${scheduleId}&presence=${presence}&student_profile_id=${personId}`,
    cache: false,
    method: 'POST',
    dataType: 'json',
  });
}

export function markPresence(personId, scheduleId, id, presence) {
  return {
    personId,
    scheduleId,
    type: actionTypes.MARK_PRESENCE,
    attendance: { id, presence },
  };
}

export function markUnknown(personId, scheduleId) {
  return {
    personId,
    scheduleId,
    type: actionTypes.MARK_UNKNOWN,
  };
}

export function asyncMarkPresence(personId, scheduleId, attendanceId, currentPresence, neededPresence) {
  return (dispatch) => {
    if (currentPresence === neededPresence) return;

    const success = ({ attendance: { id, presence } }) => dispatch(markPresence(personId, scheduleId, id, presence));

    if (attendanceId) {
      updateAttendance(attendanceId, neededPresence, success);
    } else {
      createAttendance(personId, scheduleId, neededPresence, success);
    }
  };
}

export function asyncMarkUnknown(personId, scheduleId, attendanceId) {
  return (dispatch) => {
    if (!attendanceId) return;

    deleteAttendance(attendanceId, () => dispatch(markUnknown(personId, scheduleId)));
  };
}

export function getAttendance() {
  return (dispatch, getState) => {
    const { groupAttendanceStore: { page, academicGroupId } } = getState();

    const nextPage = page + 1;

    $.ajax({
      url: `/ui/schedule_attendances?page=${nextPage}&academic_group_id=${academicGroupId}`,
      dataType: 'json',
      cache: false,
      success: data => {
        if (data.classSchedules && data.classSchedules.length) {
          dispatch(updateClassSchedulesAndPage(data.classSchedules, nextPage));
        }
      },

      error: (xhr, status, err) => {
      },
    });
  };
}
