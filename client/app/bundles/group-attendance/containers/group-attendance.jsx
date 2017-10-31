import React, { PropTypes } from 'react';
import AttendanceSubmitter from '../components/attendance-submitter';
import GroupAttendanceWidget from '../components/group-attendance-widget';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as groupAttendanceActionCreators from '../actions/group-attendance-action-creators';

import work from 'webworkify-webpack';

const AttendanceWorker = work(require.resolve('../workers/attendance-worker.js'));

function select(state) {
  return { groupAttendanceStore: state.groupAttendanceStore };
}

class GroupAttendance extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    groupAttendanceStore: PropTypes.object.isRequired,
  };

  actions = () => bindActionCreators(groupAttendanceActionCreators, this.props.dispatch);

  componentDidMount() {
    const actions = this.actions();

    actions.getAttendance();

    AttendanceWorker.addEventListener('message', msg => {
      actions.workerReplyDispatcher(JSON.parse(msg.data));
    });
  }

  postToWorker(msg) {
    AttendanceWorker.postMessage(JSON.stringify(msg));
  }

  asyncMarkUnknown = attendance => {
    this.actions().asyncMarkUnknown(this.postToWorker, attendance);
  };

  asyncMarkPresence = (attendance, presence) => {
    this.actions().asyncMarkPresence(this.postToWorker, attendance, presence);
  };

  render() {
    const {
      people,
      loading,
      canManage,
      defaultPhoto,
      localization,
      classSchedules,
      selectedPersonIndex,
      selectedScheduleIndex,
    } = this.props.groupAttendanceStore;

    const {
      nextPerson,
      getAttendance,
      previousPerson,
      openAttendanceSubmitter,
    } = this.actions();

    const {
      asyncMarkUnknown,
      asyncMarkPresence,
    } = this;

    return (
      <div className="row">
        <GroupAttendanceWidget
          {...{
            people,
            loading,
            canManage,
            getAttendance,
            classSchedules,
            openAttendanceSubmitter,
          }}
        />

        {canManage ?
          <AttendanceSubmitter
            {
              ...{
                data: {
                  people,
                  defaultPhoto,
                  localization,
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
        :
          null
        }
      </div>
    );
  }
}

// Don't forget to actually use connect!
// Note that we don't export groupAttendance, but the redux "connected" version of it.
// See https://github.com/reactjs/react-redux/blob/master/docs/api.md#examples
export default connect(select)(GroupAttendance);
