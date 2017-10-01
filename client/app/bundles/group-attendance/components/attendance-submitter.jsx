import React from 'react';

export default class AttendanceSubmitter extends React.Component {
  render() {
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

              <h4 className="modal-title" id="gridSystemModalLabel">Modal title</h4>
            </div>
            <div className="modal-body">
              <div className="row">
                <div className="col-md-4">.col-md-4</div>
                <div className="col-md-4 col-md-offset-4">.col-md-4 .col-md-offset-4</div>
              </div>
              <div className="row">
                <div className="col-md-3 col-md-offset-3">.col-md-3 .col-md-offset-3</div>
                <div className="col-md-2 col-md-offset-4">.col-md-2 .col-md-offset-4</div>
              </div>
              <div className="row">
                <div className="col-md-6 col-md-offset-3">.col-md-6 .col-md-offset-3</div>
              </div>
              <div className="row">
                <div className="col-sm-9">
                  Level 1: .col-sm-9
                  <div className="row">
                    <div className="col-xs-8 col-sm-6">
                      Level 2: .col-xs-8 .col-sm-6
                    </div>
                    <div className="col-xs-4 col-sm-6">
                      Level 2: .col-xs-4 .col-sm-6
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-default" data-dismiss="modal">Close</button>
              <button type="button" className="btn btn-primary">Save changes</button>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
