import mirrorCreator from 'mirror-creator';

const actionTypes = mirrorCreator([
  'SHOW_LOADER',
  'HIDE_LOADER',
  'NEXT_PERSON',
  'MARK_UNKNOWN',
  'MARK_PRESENCE',
  'PREVIOUS_PERSON',
  'OPEN_ATTENDANCE_SUBMITTER',
  'UPDATE_CLASS_SCHEDULES_AND_PAGE',
]);

export default actionTypes;
