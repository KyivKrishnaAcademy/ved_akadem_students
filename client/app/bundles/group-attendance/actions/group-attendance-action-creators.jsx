import $ from 'jquery'; // eslint-disable-line id-length
import actionTypes from '../constants/group-attendance-constants';

export function openAttendanceSubmitter(selectedScheduleId) {
  $('#attendanceSubmitterModal').modal('show');

  return {
    selectedScheduleId,
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
