import actionTypes from '../constants/group-performance-constants';

export const initialState = {
  loading: false,
  editRowExaminationId: 0,
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

    case actionTypes.OPEN_EXAMINATION_RESULT_EDITOR:
      return {
        ...state,
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
