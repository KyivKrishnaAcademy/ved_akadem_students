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

export function resultDeleted(examinationId, studentProfileId) {
  return {
    examinationId,
    studentProfileId,
    type: actionTypes.RESULT_DELETED,
  };
}

export function resultSaved(examinationResult) {
  return {
    examinationResult,
    type: actionTypes.RESULT_SAVED,
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

function deleteResult(resultId, success, error) {
  $.ajax({
    error,
    success,
    url: `/ui/examination_results/${resultId}`,
    cache: false,
    method: 'DELETE',
    dataType: 'json',
  });
}

function updateResult(resultId, score, success, error) {
  $.ajax({
    error,
    success,
    url: `/ui/examination_results/${resultId}`,
    data: { score },
    cache: false,
    method: 'PUT',
    dataType: 'json',
  });
}

function createResult(examinationId, studentProfileId, score, success, error) {
  $.ajax({
    error,
    success,
    url: `/ui/examination_results`,
    data: {
      score,
      examination_id: examinationId, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
      student_profile_id: studentProfileId, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
    },
    cache: false,
    method: 'POST',
    dataType: 'json',
  });
}

export function asyncDeleteResult(resultId, examinationId, studentProfileId) {
  return (dispatch) => {
    if (!resultId) return;

    dispatch(showLoader());

    const error = () => dispatch(hideLoader());
    const success = () => {
      dispatch(hideLoader());
      dispatch(resultDeleted(examinationId, studentProfileId));
    };

    deleteResult(resultId, success, error);
  };
}

export function asyncSaveResult(id, score, examinationId, studentProfileId) {
  return (dispatch) => {
    dispatch(showLoader());

    const error = () => dispatch(hideLoader());
    const success = ({ examinationResult }) => {
      dispatch(hideLoader());
      dispatch(resultSaved(examinationResult));
    };

    if (id) {
      updateResult(id, score, success, error);
    } else {
      createResult(examinationId, studentProfileId, score, success, error);
    }
  };
}
