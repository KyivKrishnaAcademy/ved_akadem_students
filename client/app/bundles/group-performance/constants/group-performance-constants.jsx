import mirrorCreator from 'mirror-creator';

const actionTypes = mirrorCreator([
  'SHOW_LOADER',
  'HIDE_LOADER',
  'RESULT_SAVED',
  'RESULT_DELETED',
  'TOGGLE_EDIT_ROW',
  'OPEN_EXAMINATION_RESULT_EDITOR',
]);

export default actionTypes;
