import React, { PropTypes } from 'react';

const Loader = ({ icon, onClick, subClass }) =>
  <button className={`btn btn-sm btn-${subClass}`} onClick={onClick}>
    <span className={`glyphicon glyphicon-${icon}`} aria-hidden="true" />
  </button>
;

Loader.propTypes = {
  icon: PropTypes.string.isRequired,
  onClick: PropTypes.func.isRequired,
  subClass: PropTypes.string.isRequired,
};

export default Loader;
