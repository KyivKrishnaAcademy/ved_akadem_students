import $ from 'jquery';
import React, { PropTypes } from 'react';
import bindAll from '../../../lib/helpers/bind-all';

export default class GroupAttendanceWidget extends React.Component {
  static propTypes = {
    people: PropTypes.arrayOf(PropTypes.shape({
      name: PropTypes.string.isRequired,
    })).isRequired,
    openAttendanceSubmitter: PropTypes.func.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    bindAll(this, 'openAttendanceSubmitter');
  }

  openAttendanceSubmitter() {
    this.props.openAttendanceSubmitter(1);
  }

  componentDidUpdate() {
    $('.people-header').height($('.attendance-header').height());
  }

  render() {
    const { people } = this.props;

    const peopleNames = people.map(person =>
      <div className="cell person-name" key={person.name}>{person.name}</div>
    );

    const ids = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];
    const attendanceRows = ids.map(id =>
      <div key={id} className="attendance-row">
        <div className="attendance-header">
          <div className="time-n-place vert-offset-bottom-1">
            <b>Бхакті Ваібхава</b>
            <br/>
            Пн. 2017-09-18
          </div>

          <button className="btn btn-sm btn-primary" onClick={this.openAttendanceSubmitter}>
            <span className="glyphicon glyphicon-pencil" aria-hidden="true" />
          </button>
        </div>

        <div className="cell">.</div>
        <div className="cell">.</div>
        <div className="cell">.</div>
        <div className="cell">.</div>
      </div>
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
