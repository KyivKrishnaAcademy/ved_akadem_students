export function readObjectFromStorage(key) {
  const fetched = localStorage.getItem(key);

  return fetched ? JSON.parse(fetched) : {};
}

export function writeObjectToStorage(key, object) {
  localStorage.setItem(key, JSON.stringify(object));
}

export function writeAttendanceToStorage(attendance) {
  const attendances = readObjectFromStorage('attendances');
  const { scheduleId, studentProfileId } = attendance;
  const key = `${scheduleId}-${studentProfileId}`;

  attendances[key] = attendance;

  writeObjectToStorage('attendances', attendances);
}

export function deleteAttendanceFromStorage(attendance) {
  const attendances = readObjectFromStorage('attendances');
  const { scheduleId, studentProfileId } = attendance;
  const key = `${scheduleId}-${studentProfileId}`;

  delete attendances[key];

  writeObjectToStorage('attendances', attendances);
}

export function mergeLocalAttendances(classSchedules) {
  const attendances = readObjectFromStorage('attendances');
  const classSchedulesObj = {};
  const orderedScheduleIds = [];

  classSchedules.forEach(classSchedule => {
    const id = classSchedule.id;

    orderedScheduleIds.push(id);

    classSchedulesObj[id] = classSchedule;
  });

  Object.keys(attendances).forEach(key => {
    const splittedKey = key.split('-');
    const scheduleId = splittedKey[0];
    const studentProfileId = splittedKey[1];

    const classSchedule = classSchedulesObj[scheduleId];

    if (classSchedule) {
      const apiAttendance = classSchedule.attendances[studentProfileId];
      const localAttendance = attendances[key];

      if (!apiAttendance || apiAttendance.revision === localAttendance.revision) {
        classSchedulesObj[scheduleId].attendances[studentProfileId] = localAttendance;
      } else {
        delete attendances[key];
      }
    }
  });

  writeObjectToStorage('attendances', attendances);

  return orderedScheduleIds.map(key => classSchedulesObj[key]);
}

export default {
  mergeLocalAttendances,
  writeAttendanceToStorage,
  deleteAttendanceFromStorage,
};
