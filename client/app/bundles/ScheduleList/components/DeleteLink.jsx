import React, { PropTypes } from 'react';

const DeleteLink = ({ condition, path }) => {
  if (condition) {
    return (
      <a data-confirm="Are you sure?"
        className="btn btn-xs btn-danger"
        rel="nofollow"
        data-method="delete"
        href={path}
      >
        <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
      </a>
    );
  }

  return <span />;
};

DeleteLink.propTypes = {
  condition: PropTypes.bool.isRequired,
  path: PropTypes.string.isRequired,
};

export default DeleteLink;
