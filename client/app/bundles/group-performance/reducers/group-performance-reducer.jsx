import actionTypes from '../constants/group-performance-constants';

export const initialState = {
  loading: false,
  editExaminationId: 0,
  editRowExaminationId: 0,
  editStudentProfileId: 0,
};

export default function groupPerformanceReducer(state = initialState, action) {
  switch (action.type) {
    case actionTypes.SHOW_LOADER:
      return {
        ...state,
        loading: true,
      };

    case actionTypes.HIDE_LOADER:
      return {
        ...state,
        loading: false,
      };

    case actionTypes.RESULT_SAVED:
      return {
        ...state,

        examinationResults: {
          ...state.examinationResults,

          [action.examinationResult.examinationId]: {
            ...state.examinationResults[action.examinationResult.examinationId],

            [action.examinationResult.studentProfileId]: action.examinationResult,
          },
        },
      };

    case actionTypes.RESULT_DELETED:
      return {
        ...state,

        examinationResults: {
          ...state.examinationResults,

          [action.examinationId]: {
            ...state.examinationResults[action.examinationId],

            [action.studentProfileId]: {},
          },
        },
      };

    case actionTypes.OPEN_EXAMINATION_RESULT_EDITOR:
      return {
        ...state,
        editExaminationId: action.examinationId,
        editStudentProfileId: action.personId,
      };

    case actionTypes.TOGGLE_EDIT_ROW:
      return {
        ...state,
        editRowExaminationId: state.editRowExaminationId === action.examinationId ? 0 : action.examinationId,
      };

    default:
      return state;
  }
}
