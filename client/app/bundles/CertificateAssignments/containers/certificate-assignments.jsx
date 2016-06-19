import React, { PropTypes } from 'react';
import CertificateAssignmentsWidget from '../components/certificate-assignments-widget';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as certificateAssignmentsActionCreators from '../actions/certificate-assignments-action-creators';
import Switch from 'react-bootstrap-switch';

function select(state) {
  return { certificateAssignmentsStore: state.certificateAssignmentsStore };
}

class CertificateAssignments extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    certificateAssignmentsStore: PropTypes.object.isRequired,
  };

  constructor(props, context) {
    super(props, context);
  }

  render() {
    const { dispatch, certificateAssignmentsStore } = this.props;
    const actions = bindActionCreators(certificateAssignmentsActionCreators, dispatch);
    const { updateName } = actions;
    const name = certificateAssignmentsStore.name;

    return (
      <div>
        <div className="row vert-offset-top-1">
          <div className="col-xs-12">
            <Switch
              size="mini"
              onColor="danger"
              offColor="success"
              labelText="writeable"
              state={false}
            />
          </div>
        </div>

        <CertificateAssignmentsWidget {...{ updateName, name }} />
      </div>
    );
  }
}

// Don't forget to actually use connect!
// Note that we don't export CertificateAssignments, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(CertificateAssignments);
