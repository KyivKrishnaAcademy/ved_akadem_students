import React, { PropTypes } from 'react';

const EditLink = ({ condition, path }) => {
  if (condition) {
    return (
      <a className="btn btn-xs btn-primary" href={path}>
        <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
      </a>
    );
  }

  return <span />;
};

EditLink.propTypes = {
  condition: PropTypes.bool.isRequired,
  path: PropTypes.string.isRequired,
};

export default EditLink;
