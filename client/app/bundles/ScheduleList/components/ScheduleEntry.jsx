import React, { PropTypes } from 'react';

export default class ScheduleEntry extends React.Component {
  static propTypes = {
    schedule: PropTypes.object.isRequired,
  };

  _linkOrText(condition, path, text) {
    if (condition) { return (<a href={path}>{text}</a>); }

    return text;
  }

  _lectorLinkOrText(lector) {
    if (lector) { return this._linkOrText(lector.canView, lector.path, lector.complexName); }

    return '';
  }

  _editLink(schedule) {
    if (schedule.canEdit) {
      return (
        <a className="btn btn-xs btn-primary" href={schedule.editPath}>
          <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
        </a>
      );
    }
  }

  _deleteLink(schedule) {
    if (schedule.canDelete) {
      return (
        <a data-confirm="Are you sure?"
          className="btn btn-xs btn-danger"
          rel="nofollow"
          data-method="delete"
          href={schedule.deletePath}
        >
          <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
        </a>
      );
    }
  }

  render() {
    const schedule = this.props.schedule;
    const groups = schedule.academicGroups.map((group) =>
      <span key={group.id}>{this._linkOrText(group.canView, group.path, group.title)}</span>
    );

    return (
      <tr>
        <td>
          {this._linkOrText(schedule.course.canView, schedule.course.path, schedule.course.title)}
        </td>
        <td>{this._lectorLinkOrText(schedule.lector)}</td>
        <td>{schedule.subject}</td>
        <td>{groups}</td>
        <td>{schedule.classroom}</td>
        <td>{schedule.time}</td>
        <td>{this._editLink(schedule)} {this._deleteLink(schedule)}</td>
      </tr>
    );
  }
}
