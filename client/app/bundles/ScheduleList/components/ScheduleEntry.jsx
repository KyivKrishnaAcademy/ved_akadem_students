import React, { PropTypes } from 'react';
import LinkOrText from './LinkOrText';
import LectorLinkOrText from './LectorLinkOrText';
import EditLink from './EditLink';
import DeleteLink from './DeleteLink';
import GroupsLinks from './GroupsLinks';

const ScheduleEntry = ({ schedule }) => (
  <tr>
    <td>
      <LinkOrText
        condition={schedule.course.canView}
        path={schedule.course.path}
        text={schedule.course.title}
      />
    </td>
    <td><LectorLinkOrText lector={schedule.lector} /></td>
    <td>{schedule.subject}</td>
    <GroupsLinks groups={schedule.academicGroups}/>
    <td>{schedule.classroom}</td>
    <td>{schedule.time}</td>
    <td>
      <EditLink
        condition={schedule.canEdit}
        path={schedule.editPath}
      />
      {' '}
      <DeleteLink
        condition={schedule.canDelete}
        path={schedule.deletePath}
      />
    </td>
  </tr>
);

ScheduleEntry.propTypes = {
  schedule: PropTypes.object.isRequired,
};

export default ScheduleEntry;
