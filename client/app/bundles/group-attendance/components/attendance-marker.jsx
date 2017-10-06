import React, { PropTypes } from 'react';

const AttendanceMarker = ({ status }) => {
  if (status === true) return <div className="cell bg-success">.</div>;
  if (status === false) return <div className="cell bg-danger">н</div>;

  return <div className="cell">{'\u00A0'}</div>;
};

AttendanceMarker.propTypes = {
  status: PropTypes.bool,
};

export default AttendanceMarker;
