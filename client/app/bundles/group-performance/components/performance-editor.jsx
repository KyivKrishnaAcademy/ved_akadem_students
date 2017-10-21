import React from 'react';
import Slider from 'react-rangeslider';

import Loader from '../../../lib/components/loader';

export default class PerformanceEditor extends React.Component {
  static propTypes = {

  };

  constructor(props, context) {
    super(props, context);

    this.state = {
      value: 10,
    };
  }

  handleChangeStart = () => {
    console.log('Change event started');
  };

  handleChange = value => {
    this.setState({
      value,
    });
  };

  handleChangeComplete = () => {
    console.log('Change event completed');
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
    // const {
    //   data: { people, loading, localization, selectedPersonIndex },
    //   actions: { nextPerson, previousPerson },
    // } = this.props;

    const loading = false;

    const { value } = this.state;

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
                <b>classSchedule.courseTitle</b>
                <br/>
                classSchedule.date
              </h4>
            </div>

            <div className="modal-body">
              <div className="row">
                <div className="col-sm-12">
                  <h4 className="text-center">
                    person.name

                    <div className="slider">
                      <Slider
                        min={0}
                        max={100}
                        value={value}
                        onChangeStart={this.handleChangeStart}
                        onChange={this.handleChange}
                        onChangeComplete={this.handleChangeComplete}
                      />
                      <div className="value">{value}</div>
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
