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

export function showLoader() {
  return {
    type: actionTypes.SHOW_LOADER,
  };
}

export function hideLoader() {
  return {
    type: actionTypes.HIDE_LOADER,
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

export function markPresence(attendance) {
  return {
    attendance,
    type: actionTypes.MARK_PRESENCE,
  };
}

export function markUnknown(attendance) {
  return {
    attendance,
    type: actionTypes.MARK_UNKNOWN,
  };
}

function readObjectFromStorage(key) {
  const fetched = localStorage.getItem(key);

  return fetched ? JSON.parse(fetched) : {};
}

function writeObjectToStorage(key, object) {
  localStorage.setItem(key, JSON.stringify(object));
}

function writeAttendanceToStorage(attendance) {
  const attendances = readObjectFromStorage('attendances');
  const { scheduleId, studentProfileId } = attendance;
  const key = `${scheduleId}-${studentProfileId}`;

  attendances[key] = attendance;

  writeObjectToStorage('attendances', attendances);
}

function deleteAttendanceFromStorage(attendance) {
  const attendances = readObjectFromStorage('attendances');
  const { scheduleId, studentProfileId } = attendance;
  const key = `${scheduleId}-${studentProfileId}`;

  delete attendances[key];

  writeObjectToStorage('attendances', attendances);
}

export function workerReplyDispatcher(data) {
  return dispatch => {
    const { type, status, attendance } = data;

    if (status === 204 && type === 'deleteAttendanceReply') {
      const { scheduleId, studentProfileId } = attendance;

      dispatch(markUnknown({ scheduleId, studentProfileId }));
    } else if (status === 200 && (type === 'createAttendanceReply' || type === 'updateAttendanceReply')) {
      dispatch(markPresence(data.response.attendance));
    }

    if (status === 200 || status === 204 || status === 404) deleteAttendanceFromStorage(attendance);
  };
}

export function asyncMarkPresence(mesenger, attendance, presence) {
  return dispatch => {
    if (attendance.presence === presence) return;

    const newAttendance = { ...attendance, presence };

    writeAttendanceToStorage(newAttendance);

    dispatch(markPresence({ ...newAttendance, inSync: true }));

    mesenger({ type: 'markAttendance', attendance: newAttendance });
  };
}

export function asyncMarkUnknown(mesenger, attendance) {
  return dispatch => {
    if (!attendance.id) return;

    const newAttendance = { ...attendance, toDelete: true };

    delete newAttendance.presence;

    writeAttendanceToStorage(newAttendance);

    dispatch(markUnknown({ ...newAttendance, inSync: true }));

    mesenger({ type: 'deleteAttendance', attendance: newAttendance });
  };
}

export function getAttendance() {
  return (dispatch, getState) => {
    const { groupAttendanceStore: { page, academicGroupId } } = getState();

    const nextPage = page + 1;

    dispatch(showLoader());

    $.ajax({
      url: `/ui/schedule_attendances?page=${nextPage}&academic_group_id=${academicGroupId}`,
      dataType: 'json',
      cache: false,
      success: data => {
        if (data.classSchedules && data.classSchedules.length) {
          dispatch(updateClassSchedulesAndPage(data.classSchedules, nextPage));
        }

        dispatch(hideLoader());
      },

      error: (xhr, status, err) => dispatch(hideLoader()),
    });
  };
}
