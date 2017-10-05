import React, { PropTypes } from 'react';

const FetchAttendanceButton = ({ getAttendance }) =>
  <button className="btn btn-primary" onClick={getAttendance}>
    <span className="glyphicon glyphicon-backward" aria-hidden="true" />
    <span>{'\u00A0'}{'\u00A0'}</span>
    <span className="glyphicon glyphicon-hourglass" aria-hidden="true" />
  </button>
;

FetchAttendanceButton.propTypes = {
  getAttendance: PropTypes.func.isRequired,
};

export default FetchAttendanceButton;
