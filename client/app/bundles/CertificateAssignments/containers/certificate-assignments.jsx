import React, { PropTypes } from 'react';
import CertificateAssignmentsWidget from '../components/certificate-assignments-widget';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as certificateAssignmentsActionCreators from '../actions/certificate-assignments-action-creators';

function select(state) {
  // Which part of the Redux global state does our component want to receive as props?
  // Note the use of `` to prefix the property name because the value is of type Immutable.js
  return { certificateAssignmentsStore: state.certificateAssignmentsStore };
}

// Simple example of a React "smart" component
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

    // This uses the ES2015 spread operator to pass properties as it is more DRY
    // This is equivalent to:
    // <CertificateAssignmentsWidget certificateAssignmentsStore={certificateAssignmentsStore} actions={actions} />
    return (
      <CertificateAssignmentsWidget {...{ updateName, name }} />
    );
  }
}

// Don't forget to actually use connect!
// Note that we don't export CertificateAssignments, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(CertificateAssignments);
