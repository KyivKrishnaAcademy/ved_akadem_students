import React, { PropTypes } from 'react';
import AttendanceSubmitter from '../components/attendance-submitter';
import GroupAttendanceWidget from '../components/group-attendance-widget';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as groupAttendanceActionCreators from '../actions/group-attendance-action-creators';

function select(state) {
  return { groupAttendanceStore: state.groupAttendanceStore };
}

class GroupAttendance extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    groupAttendanceStore: PropTypes.object.isRequired,
  };

  componentDidMount() {
    const actions = bindActionCreators(groupAttendanceActionCreators, this.props.dispatch);

    actions.getAttendance();
  }

  render() {
    const { dispatch, groupAttendanceStore } = this.props;
    const actions = bindActionCreators(groupAttendanceActionCreators, dispatch);
    const { people, loading, selectedPersonIndex, classSchedules, selectedScheduleIndex } = groupAttendanceStore;

    const {
      nextPerson,
      getAttendance,
      previousPerson,
      asyncMarkUnknown,
      asyncMarkPresence,
      openAttendanceSubmitter,
    } = actions;

    return (
      <div className="row">
        <GroupAttendanceWidget {...{ people, loading, classSchedules, getAttendance, openAttendanceSubmitter }} />

        <AttendanceSubmitter
          {
            ...{
              data: {
                people,
                loading,
                classSchedules,
                selectedPersonIndex,
                selectedScheduleIndex,
              },
              actions: {
                nextPerson,
                previousPerson,
                asyncMarkUnknown,
                asyncMarkPresence,
              },
            }
          }
        />
      </div>
    );
  }
}

// Don't forget to actually use connect!
// Note that we don't export groupAttendance, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(GroupAttendance);
