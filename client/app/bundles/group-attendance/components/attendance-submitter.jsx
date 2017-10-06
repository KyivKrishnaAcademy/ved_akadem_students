import React, { PropTypes } from 'react';

import Loader from '../../../lib/components/loader';
import bindAll from '../../../lib/helpers/bind-all';

export default class AttendanceSubmitter extends React.Component {
  static propTypes = {
    data: PropTypes.shape({
      people: PropTypes.arrayOf(PropTypes.shape({
        name: PropTypes.string.isRequired,
        photoPath: PropTypes.string.isRequired,
        studentProfileId: PropTypes.number.isRequired,
      })).isRequired,
      loading: PropTypes.bool.isRequired,
      localization: PropTypes.object.isRequired,
      classSchedules: PropTypes.arrayOf(PropTypes.shape({
        id: PropTypes.number.isRequired,
        date: PropTypes.string.isRequired,
        courseTitle: PropTypes.string.isRequired,
        attendances: PropTypes.object.isRequired,
      })).isRequired,
      selectedPersonIndex: PropTypes.number.isRequired,
      selectedScheduleIndex: PropTypes.number,
    }).isRequired,
    actions: PropTypes.shape({
      nextPerson: PropTypes.func.isRequired,
      previousPerson: PropTypes.func.isRequired,
      asyncMarkUnknown: PropTypes.func.isRequired,
      asyncMarkPresence: PropTypes.func.isRequired,
    }),
  };

  constructor(props, context) {
    super(props, context);

    bindAll(
      this,
      'getPerson',
      'getSchedule',
      'markUnknown',
      'markPresence',
      'getAttendance',
    );
  }

  getPerson() {
    return this.props.data.people[this.props.data.selectedPersonIndex] || {};
  }

  getSchedule() {
    return this.props.data.classSchedules[this.props.data.selectedScheduleIndex] || {};
  }

  getAttendance() {
    return (this.getSchedule().attendances || {})[this.getPerson().studentProfileId] || {};
  }

  markUnknown() {
    this.props.actions.asyncMarkUnknown(
      this.getPerson().studentProfileId,
      this.getSchedule().id,
      this.getAttendance().id,
    );
  }

  markPresence(neededPresence) {
    return () => {
      const attendance = this.getAttendance();

      this.props.actions.asyncMarkPresence(
        this.getPerson().studentProfileId,
        this.getSchedule().id,
        attendance.id,
        attendance.presence,
        neededPresence,
      );
    };
  }

  render() {
    const {
      data: { people, loading, localization, selectedPersonIndex },
      actions: { nextPerson, previousPerson },
    } = this.props;

    const person = this.getPerson();
    const attendance = this.getAttendance();
    const classSchedule = this.getSchedule();

    const nextPersonDisabled = selectedPersonIndex === people.length - 1;
    const previousPersonDisabled = selectedPersonIndex === 0;

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
            <Loader visible={loading} />

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
                  <img className="img-thumbnail img-version-standart" src={person.photoPath} alt={person.name} />
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
                    <button
                      type="button"
                      onClick={this.markPresence(true)}
                      className={presentClass}
                    >
                      {localization.present}
                    </button>

                    <button
                      type="button"
                      onClick={this.markPresence(false)}
                      className={absentClass}
                    >
                     {localization.absend}
                    </button>

                    <button
                      type="button"
                      onClick={this.markUnknown}
                      className={unknownClass}
                    >
                      {localization.unknown}
                    </button>
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
                      disabled={previousPersonDisabled}
                      className="btn btn-default"
                    >
                      {localization.back}
                    </button>

                    <button
                      type="button"
                      onClick={nextPerson}
                      disabled={nextPersonDisabled}
                      className="btn btn-default"
                    >
                      {localization.forth}
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
