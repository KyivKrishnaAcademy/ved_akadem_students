var Schedule = React.createClass({
  propTypes: {
    schedule: React.PropTypes.object.isRequired
  },

  render: function() {
    var schedule   = this.props.schedule;
    var linkOrText = function(condition, path, text) {
      if (condition) {
        return (<a href={path}>{text}</a>);
      } else {
        return text;
      }
    };
    var editLink = function(schedule) {
      if (schedule.can_edit) {
        return (
          <a className="btn btn-xs btn-primary" href={schedule.edit_path}>
            <span className="glyphicon glyphicon-pencil" aria-hidden="true"></span>
          </a>
        );
      }
    };
    var deleteLink = function(schedule) {
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

    return (
      <tr>
        <td>{linkOrText(schedule.course.can_view, schedule.course.path, schedule.course.title)}</td>
        <td>{linkOrText(schedule.lector.can_view, schedule.lector.path, schedule.lector.complex_name)}</td>
        <td>{schedule.subject}</td>
        <td>
          {
            schedule.academic_groups.map(function (group) {
              return <span key={group.id}>{linkOrText(group.can_view, group.path, group.title)} </span>;
            })
          }
        </td>
        <td>{schedule.classroom}</td>
        <td>{schedule.time}</td>
        <td>
          {editLink(schedule)} {deleteLink(schedule)}
        </td>
      </tr>
    );
  }
});
