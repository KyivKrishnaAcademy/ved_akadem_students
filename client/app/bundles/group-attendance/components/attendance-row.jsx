import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';
import AttendanceMarker from './attendance-marker';

export default class AttendanceRow extends React.Component {
  static propTypes = {
    canManage: PropTypes.bool.isRequired,
    peopleIds: PropTypes.arrayOf(PropTypes.number).isRequired,
    classSchedule: PropTypes.shape({
      id: PropTypes.number.isRequired,
      date: PropTypes.string.isRequired,
      courseTitle: PropTypes.string.isRequired,
      attendances: PropTypes.object.isRequired,
    }).isRequired,
    scheduleIndex: PropTypes.number.isRequired,
    openAttendanceSubmitter: PropTypes.func.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    bindAll(this, 'openAttendanceSubmitter');
  }

  openAttendanceSubmitter() {
    this.props.openAttendanceSubmitter(this.props.scheduleIndex);
  }

  render() {
    const { canManage, peopleIds, classSchedule: { date, courseTitle, attendances } } = this.props;

    const attendanceMarkers = peopleIds.map(personId =>
      <AttendanceMarker key={personId} status={attendances[personId] && attendances[personId].presence} />
    );

    const editButton = canManage
      ?
        <button className="btn btn-sm btn-primary" onClick={this.openAttendanceSubmitter}>
          <span className="glyphicon glyphicon-pencil" aria-hidden="true" />
        </button>
      : null;

    return (
      <div className="attendance-row">
        <div className="attendance-header">
          <div className="time-n-place vert-offset-bottom-1">
            <b>{courseTitle}</b>
            <br/>
            {date}
          </div>

          {editButton}
        </div>

        {attendanceMarkers}
      </div>
    );
  }
}
