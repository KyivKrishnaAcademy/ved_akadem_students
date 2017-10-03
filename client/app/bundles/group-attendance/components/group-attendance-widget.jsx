import $ from 'jquery'; // eslint-disable-line id-length
import React, { PropTypes } from 'react';

import AttendanceRow from './attendance-row';

export default class GroupAttendanceWidget extends React.Component {
  static propTypes = {
    people: PropTypes.arrayOf(PropTypes.shape({
      name: PropTypes.string.isRequired,
    })).isRequired,
    classSchedules: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number.isRequired,
      date: PropTypes.string.isRequired,
      courseTitle: PropTypes.string.isRequired,
      attendances: PropTypes.object.isRequired,
    })).isRequired,
    openAttendanceSubmitter: PropTypes.func.isRequired,
  };

  componentDidUpdate() {
    $('.people-header').height($('.attendance-header').height());
  }

  render() {
    const { people, classSchedules, openAttendanceSubmitter } = this.props;

    const peopleIds = people.map(person => person.studentProfileId);
    const peopleNames = people.map(person =>
      <div className="cell person-name" key={person.name}>{person.name}</div>
    );

    const attendanceRows = classSchedules.map(classSchedule =>
      <AttendanceRow
        key={classSchedule.id}
        peopleIds={peopleIds}
        classSchedule={classSchedule}
        openAttendanceSubmitter={openAttendanceSubmitter}
      />
    );

    return (
      <div className="groupAttendanceTable col-xs-12 vert-offset-top-1 vert-offset-bottom-3">
        <div className="people-row">
          <div className="people-header" />

          {peopleNames}
        </div>

        <div className="attendance-rows">
          {attendanceRows}
        </div>
      </div>
    );
  }
}
