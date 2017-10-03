import React, { PropTypes } from 'react';

export default class AttendanceSubmitter extends React.Component {
  static propTypes = {
    people: PropTypes.arrayOf(PropTypes.shape({
      name: PropTypes.string.isRequired,
      photoPath: PropTypes.string.isRequired,
      studentProfileId: PropTypes.number.isRequired,
    })).isRequired,
    classSchedules: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number.isRequired,
      date: PropTypes.string.isRequired,
      courseTitle: PropTypes.string.isRequired,
      attendances: PropTypes.object.isRequired,
    })).isRequired,
    nextPerson: PropTypes.func.isRequired,
    previousPerson: PropTypes.func.isRequired,
    selectedPersonIndex: PropTypes.number.isRequired,
    selectedScheduleIndex: PropTypes.number,
  };

  render() {
    const { nextPerson, previousPerson } = this.props;

    const person = this.props.people[this.props.selectedPersonIndex];
    const classSchedule = this.props.classSchedules[this.props.selectedScheduleIndex] || {};
    const attendance = (classSchedule.attendances || {})[person.studentProfileId] || {};

    let bodyClass = 'modal-body';
    let absentClass = 'btn btn-danger';
    let presentClass = 'btn btn-success';
    let unknownClass = 'btn btn-default';

    if (attendance.presence === true) {
      bodyClass = `${bodyClass} bg-success`;
      presentClass = `${presentClass} active`;
    } else if (attendance.presence === false) {
      bodyClass = `${bodyClass} bg-danger`;
      absentClass = `${absentClass} active`;
    } else {
      unknownClass = `${unknownClass} active`;
    }

    return (
      <div
        id="attendanceSubmitterModal"
        role="dialog"
        tabIndex="-1"
        className="modal fade"
        aria-labelledby="gridSystemModalLabel"
      >
        <div className="modal-dialog" role="document">
          <div className="modal-content">
            <div className="modal-header">
              <button
                type="button"
                className="close"
                data-dismiss="modal"
                aria-label="Close"
              >
                <span aria-hidden="true">&times;</span>
              </button>

              <h4 className="modal-title text-center">
                <b>{classSchedule.courseTitle}</b>
                <br/>
                {classSchedule.date}
              </h4>
            </div>

            <div className={bodyClass}>
              <div className="row">
                <div className="col-sm-12 text-center">
                  <img className="img-thumbnail" src={person.photoPath} alt={person.name} />
                </div>
              </div>

              <div className="row">
                <div className="col-sm-12">
                  <h4 className="text-center">
                    {person.name}
                  </h4>
                </div>

                <div className="col-sm-12 text-center">
                  <div className="btn-group" role="group">
                    <button type="button" className={presentClass}>Присутній</button>
                    <button type="button" className={absentClass}>Відсутній</button>
                    <button type="button" className={unknownClass}>Невідомо</button>
                  </div>
                </div>
              </div>
            </div>

            <div className="modal-footer text-center">
              <div className="row">
                <div className="col-sm-12 text-center">
                  <div className="btn-group" role="group">
                    <button
                      type="button"
                      onClick={previousPerson}
                      className="btn btn-default"
                    >
                      Назад
                    </button>

                    <button
                      type="button"
                      onClick={nextPerson}
                      className="btn btn-default"
                    >
                      Вперед
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
