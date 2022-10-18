import React, { PropTypes } from 'react';

const IconButton = ({ color, icon, onClick, size, tooltip }) =>
  <button
    className={`btn btn-${size} btn-${color}`}
    data-toggle="tooltip"
    onClick={onClick}
    title={tooltip}
  >
    <span className={`glyphicon glyphicon-${icon}`} aria-hidden="true" />
  </button>
;

IconButton.defaultProps = {
  color: 'default',
  size: '',
};

IconButton.propTypes = {
  color: PropTypes.string.isRequired,
  icon: PropTypes.string.isRequired,
  onClick: PropTypes.func.isRequired,
  size: PropTypes.string.isRequired,
  tooltip: PropTypes.string,
};

export default IconButton;
