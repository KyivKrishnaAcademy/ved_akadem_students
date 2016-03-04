import React, { PropTypes } from 'react';

const LinkOrText = ({ condition, path, text }) => {
  if (condition) { return (<a href={path}>{text}</a>); }

  return <span>{text}</span>;
};

LinkOrText.propTypes = {
  condition: PropTypes.bool.isRequired,
  path: PropTypes.string.isRequired,
  text: PropTypes.string.isRequired,
};

export default LinkOrText;
