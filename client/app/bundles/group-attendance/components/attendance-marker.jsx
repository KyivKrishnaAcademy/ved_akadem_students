import React, { PropTypes } from 'react';

const AttendanceMarker = ({ inSync, presence }) => {
  const spinner = <span className="glyphicon glyphicon-refresh" aria-hidden="true" />;

  if (presence === true) return <div className="cell bg-success">{inSync ? spinner : '.'}</div>;
  if (presence === false) return <div className="cell bg-danger">{inSync ? spinner : 'н'}</div>;

  return <div className="cell">{inSync ? spinner : '\u00A0'}</div>;
};

AttendanceMarker.propTypes = {
  inSync: PropTypes.bool,
  presence: PropTypes.bool,
};

export default AttendanceMarker;
