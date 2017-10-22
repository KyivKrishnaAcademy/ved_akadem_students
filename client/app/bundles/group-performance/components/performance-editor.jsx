import React, { PropTypes } from 'react';
import Slider from 'react-rangeslider';

import Loader from '../../../lib/components/loader';

export default class PerformanceEditor extends React.Component {
  static propTypes = {
    data: PropTypes.shape({
      people: PropTypes.arrayOf(PropTypes.shape({
        name: PropTypes.string.isRequired,
        studentProfileId: PropTypes.number.isRequired,
      })).isRequired,
      editPersonId: PropTypes.number.isRequired,
      examinations: PropTypes.array.isRequired,
      editExaminationId: PropTypes.number.isRequired,
      examinationResults: PropTypes.object.isRequired,
    }).isRequired,
  };

  constructor(props, context) {
    super(props, context);

    const { data: { editPersonId, editExaminationId, examinationResults } } = props;

    this.state = {
      value: (examinationResults[editExaminationId] || {})[editPersonId] || 0,
    };
  }

  handleChange = value => {
    this.setState({
      value,
    });
  };

  // constructor(props, context) {
  //   super(props, context);

  //   bindAll(
  //     this,
  //     'getPerson',
  //     'getSchedule',
  //     'markUnknown',
  //     'markPresence',
  //     'getAttendance',
  //   );
  // }

  // markUnknown() {
  //   this.props.actions.asyncMarkUnknown(
  //     this.getPerson().studentProfileId,
  //     this.getSchedule().id,
  //     this.getAttendance().id,
  //   );
  // }

  // markPresence(neededPresence) {
  //   return () => {
  //     const attendance = this.getAttendance();

  //     this.props.actions.asyncMarkPresence(
  //       this.getPerson().studentProfileId,
  //       this.getSchedule().id,
  //       attendance.id,
  //       attendance.presence,
  //       neededPresence,
  //     );
  //   };
  // }

  render() {
    const {
      data: { people, editPersonId, examinations, editExaminationId },
    } = this.props;

    const loading = false;
    const person = people.find(psn => psn.studentProfileId === editPersonId) || {};
    const examination = examinations.find(ex => ex.id === editExaminationId) || {};

    const { value } = this.state;

    const labels = {
      [examination.minResult]: 'min',
      [examination.passingScore]: 'passing',
      [examination.maxResult]: 'max',
    };

    return (
      <div
        id="examinationResultEditorModal"
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
                <b>{person.name}</b>
                <br/>
                <b>{examination.title}</b>
                <br/>
                {examination.courseTitle}
              </h4>
            </div>

            <div className="modal-body">
              <div className="row">
                <div className="col-sm-12">
                  <h4 className="text-center">
                    <p>{examination.description}</p>

                    <div className="slider custom-labels">
                      <Slider
                        min={examination.minResult || 0}
                        max={examination.maxResult || 1}
                        value={value}
                        labels={labels}
                        onChange={this.handleChange}
                        handleLabel={value}
                      />
                    </div>
                  </h4>
                </div>
              </div>
            </div>

            <div className="modal-footer text-center">
              <div className="row">
                <div className="col-sm-12 text-center">
                  footer
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
