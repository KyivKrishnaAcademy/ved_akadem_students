import $ from 'jquery'; // eslint-disable-line id-length
import actionTypes from '../constants/group-performance-constants';

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

export function toggleEditRow(examinationId) {
  return {
    examinationId,
    type: actionTypes.TOGGLE_EDIT_ROW,
  };
}

export function openExaminationResultEditor(personId, examinationId) {
  $('#examinationResultEditorModal').modal('show');

  return {
    personId,
    examinationId,
    type: actionTypes.OPEN_EXAMINATION_RESULT_EDITOR,
  };
}
