import $ from 'jquery'; // eslint-disable-line id-length
import React, { PropTypes } from 'react';

import Loader from '../../../lib/components/loader';
import AttendanceRow from './attendance-row';
import FetchAttendanceButton from './fetch-attendance-button';

export default class GroupAttendanceWidget extends React.Component {
  static propTypes = {
    people: PropTypes.arrayOf(PropTypes.shape({
      name: PropTypes.string.isRequired,
    })).isRequired,
    loading: PropTypes.bool.isRequired,
    canManage: PropTypes.bool.isRequired,
    classSchedules: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number.isRequired,
      date: PropTypes.string.isRequired,
      courseTitle: PropTypes.string.isRequired,
      attendances: PropTypes.object.isRequired,
    })).isRequired,
    getAttendance: PropTypes.func.isRequired,
    openAttendanceSubmitter: PropTypes.func.isRequired,
  };

  componentDidUpdate() {
    window.adjustAttendanceHeaders();
  }

  render() {
    const { people, loading, canManage, classSchedules, getAttendance, openAttendanceSubmitter } = this.props;

    const peopleIds = people.map(person => person.studentProfileId);
    const peopleNames = people.map(person =>
      <div className="cell person-name" key={person.name}>{person.name}</div>
    );

    const attendanceRows = classSchedules.map((classSchedule, index) =>
      <AttendanceRow
        key={index}
        canManage={canManage}
        peopleIds={peopleIds}
        scheduleIndex={index}
        classSchedule={classSchedule}
        openAttendanceSubmitter={openAttendanceSubmitter}
      />
    );

    return (
      <div className="groupAttendanceTable col-xs-12 vert-offset-top-1 vert-offset-bottom-3">
        <Loader visible={loading} />

        <div className="people-row">
          <div className="people-header">
            <FetchAttendanceButton {...{ getAttendance }} />
          </div>

          {peopleNames}
        </div>

        <div className="attendance-rows">
          {attendanceRows}
        </div>
      </div>
    );
  }
}
