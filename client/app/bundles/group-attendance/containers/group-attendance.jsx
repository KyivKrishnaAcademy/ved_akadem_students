import React, { PropTypes } from 'react';
import GroupAttendanceWidget from '../components/group-attendance-widget';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as groupAttendanceActionCreators from '../actions/group-attendance-action-creators';

function select(state) {
  // Which part of the Redux global state does our component want to receive as props?
  // Note the use of `` to prefix the property name because the value is of type Immutable.js
  return { groupAttendanceStore: state.groupAttendanceStore };
}

// Simple example of a React "smart" component
class GroupAttendance extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    groupAttendanceStore: PropTypes.object.isRequired,
  };

  constructor(props, context) {
    super(props, context);
  }

  render() {
    const { dispatch, groupAttendanceStore } = this.props;
    const actions = bindActionCreators(groupAttendanceActionCreators, dispatch);
    const { openAttendanceSubmitter } = actions;
    const { people } = groupAttendanceStore;

    // This uses the ES2015 spread operator to pass properties as it is more DRY
    // This is equivalent to:
    // <GroupAttendanceWidget groupAttendanceStore={groupAttendanceStore} actions={actions} />
    return (
      <div className="row groupAttendance">
        <div className="col-xs-12">
          <GroupAttendanceWidget {...{ people, openAttendanceSubmitter }} />
        </div>
      </div>
    );
  }
}

// Don't forget to actually use connect!
// Note that we don't export groupAttendance, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(GroupAttendance);
