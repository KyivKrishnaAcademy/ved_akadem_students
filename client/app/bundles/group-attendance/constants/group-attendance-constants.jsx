import mirrorCreator from 'mirror-creator';

const actionTypes = mirrorCreator([
  'NEXT_PERSON',
  'PREVIOUS_PERSON',
  'OPEN_ATTENDANCE_SUBMITTER',
  'UPDATE_CLASS_SCHEDULES_AND_PAGE',
]);

export default actionTypes;
