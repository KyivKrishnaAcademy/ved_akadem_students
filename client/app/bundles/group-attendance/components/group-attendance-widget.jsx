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

  render() {
    const { people } = this.props;

    const attendanceRows = people.map(person =>
      <tr key={person.studentProfileId}>
        <td>{person.name}</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
    );

    return (
      <div className="table-responsive">
        <table className="table table-condensed table-bordered">
          <colgroup>
            <col className="col-md-4" />
            <col className="col-md-7" />
          </colgroup>
          <thead>
            <tr>
              <th>Name</th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>23.09</button></th>
              <th><button onClick={this.openAttendanceSubmitter}>30.09</button></th>
            </tr>
          </thead>
          <tbody>
            {attendanceRows}
          </tbody>
        </table>
      </div>
    );
  }
}
