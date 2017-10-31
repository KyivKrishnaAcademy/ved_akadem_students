const actions = {
  markAttendance(attendance, poster, origin) {
    this[attendance.id ? 'updateAttendance' : 'createAttendance'](attendance, poster, origin);
  },

  deleteAttendance(attendance, poster, origin) {
    const xhr = new XMLHttpRequest();

    xhr.open('DELETE', `${origin}/ui/schedule_attendances/${attendance.id}`, false);
    xhr.setRequestHeader('Content-Type', 'application/json');

    try {
      xhr.send(JSON.stringify({
        revision: attendance.revision,
      }));
    } catch (error) {
      return poster({ attendance, status: 'error', type: 'deleteAttendanceReply' });
    }

    poster({ attendance, status: xhr.status, type: 'deleteAttendanceReply' });
  },

  updateAttendance(attendance, poster, origin) {
    const xhr = new XMLHttpRequest();

    xhr.open('PATCH', `${origin}/ui/schedule_attendances/${attendance.id}`, false);
    xhr.setRequestHeader('Content-Type', 'application/json');

    try {
      xhr.send(JSON.stringify({
        presence: attendance.presence,
        revision: attendance.revision,
      }));
    } catch (error) {
      return poster({ attendance, status: 'error', type: 'updateAttendanceReply' });
    }

    poster({
      attendance,
      type: 'updateAttendanceReply',
      status: xhr.status,
      response: xhr.status === 200 && JSON.parse(xhr.responseText),
    });
  },

  createAttendance(attendance, poster, origin) {
    const xhr = new XMLHttpRequest();

    xhr.open('POST', `${origin}/ui/schedule_attendances`, false);
    xhr.setRequestHeader('Content-Type', 'application/json');

    try {
      // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
      xhr.send(JSON.stringify({
        presence: attendance.presence,
        class_schedule_id: attendance.scheduleId,
        student_profile_id: attendance.studentProfileId,
      }));

      // jscs:enable requireCamelCaseOrUpperCaseIdentifiers
    } catch (error) {
      poster({ attendance, status: 'error', type: 'createAttendanceReply' });
    }

    poster({
      attendance,
      type: 'createAttendanceReply',
      status: xhr.status,
      response: xhr.status === 200 && JSON.parse(xhr.responseText),
    });
  },
};

module.exports = function worker(self) {
  const poster = data => self.postMessage(JSON.stringify(data));

  self.addEventListener('message', event => {
    const data = JSON.parse(event.data);

    actions[data.type](data.attendance, poster, event.currentTarget.origin);
  });
};
