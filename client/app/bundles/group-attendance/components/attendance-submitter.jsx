import React, { PropTypes } from 'react';

export default class AttendanceSubmitter extends React.Component {
  static propTypes = {
    people: PropTypes.arrayOf(PropTypes.shape({
      name: PropTypes.string.isRequired,
      photoPath: PropTypes.string.isRequired,
      studentProfileId: PropTypes.number.isRequired,
    })).isRequired,
    selectedPersonIndex: PropTypes.number.isRequired,
  };

  render() {
    const person = this.props.people[this.props.selectedPersonIndex];

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

              <h4 className="modal-title text-center">Бхакті Ваібхава, Пн. 2017-09-18</h4>
            </div>

            <div className="modal-body bg-danger">
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
                    <button type="button" className="btn btn-success active">Присутній</button>
                    <button type="button" className="btn btn-danger">Відсутній</button>
                    <button type="button" className="btn btn-default">Невідомо</button>
                  </div>
                </div>
              </div>
            </div>

            <div className="modal-footer text-center">
              <div className="row">
                <div className="col-sm-12 text-center">
                  <div className="btn-group" role="group">
                    <button type="button" className="btn btn-default">Назад</button>
                    <button type="button" className="btn btn-default">Вперед</button>
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
