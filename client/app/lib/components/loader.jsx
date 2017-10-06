import React, { PropTypes } from 'react';

const Loader = ({ visible }) => {
  if (!visible) return <div />;

  return (
    <div className="loading-wrapper">
      <i className="fa fa-refresh fa-spin fa-3x fa-fw" />

      <span className="sr-only">Loading...</span>
    </div>
  );
};

Loader.propTypes = {
  visible: PropTypes.bool.isRequired,
};

export default Loader;
