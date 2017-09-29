import actionTypes from '../constants/group-attendance-constants';

export function updateName(name) {
  return {
    type: actionTypes.TOGGLE_WRITEABLE,
    name,
  };
}
