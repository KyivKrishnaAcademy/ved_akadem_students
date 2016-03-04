import React, { PropTypes } from 'react';
import LinkOrText from './LinkOrText';

const GroupsLinks = ({ groups }) => {
  if (!groups.length) { return <td><span /></td>; }

  const groupLinks = groups.map((group) => {
    let separator = '';

    if (groups[0] !== group) {
      separator = ' ';
    }

    return (
      <span key={group.id}>
        {separator}
        <LinkOrText condition={group.canView} path={group.path} text={group.title} />
      </span>
    );
  });

  return <td>{groupLinks}</td>;
};

GroupsLinks.propTypes = {
  groups: PropTypes.array.isRequired,
};

export default GroupsLinks;
