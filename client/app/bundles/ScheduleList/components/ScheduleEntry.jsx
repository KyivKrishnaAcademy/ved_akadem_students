import React, { PropTypes } from 'react';

export default class ScheduleEntry extends React.Component {
  static propTypes = {
    schedule: PropTypes.object.isRequired
  };

  _linkOrText(condition, path, text) {
    if (condition) { return (<a href={path}>{text}</a>) } else { return text }
  }

  _lectorLinkOrText(lector) {
    if (lector) { return this._linkOrText(lector.can_view, lector.path, lector.complex_name) }

    return '';
  }

  _editLink(schedule) {
    if (schedule.can_edit) {
      return (
        <a className="btn btn-xs btn-primary" href={schedule.edit_path}>
          <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
        </a>
      );
    }
  }

  _deleteLink(schedule) {
    if (schedule.can_delete) {
      return(
        <a data-confirm="Are you sure?"
           className="btn btn-xs btn-danger"
           rel="nofollow"
           data-method="delete"
           href={schedule.delete_path}>
            <span className="glyphicon glyphicon-trash" aria-hidden="true"></span>
        </a>
      );
    }
  };

  render() {
    const schedule = this.props.schedule,
          // TODO use => !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          groups = schedule.academic_groups.map(function (group) {
            return(<span key={group.id}>
              {this._linkOrText(group.can_view, group.path, group.title)}
            </span>);
          }.bind(this));

    return (
      <tr>
        <td>
          {this._linkOrText(schedule.course.can_view, schedule.course.path, schedule.course.title)}
        </td>
        <td>{this._lectorLinkOrText(schedule.lector)}</td>
        <td>{groups}</td>
        <td>{schedule.classroom}</td>
        <td>{schedule.time}</td>
        <td>{this._editLink(schedule)} {this._deleteLink(schedule)}</td>
      </tr>
    );
  }
}
