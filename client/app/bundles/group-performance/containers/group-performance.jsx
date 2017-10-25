import { connect } from 'react-redux';
import React, { PropTypes } from 'react';

import PerformanceEditor from '../components/performance-editor';
import GroupPerformanceWidget from '../components/group-performance-widget';

import { bindActionCreators } from 'redux';
import * as groupPerformanceActionCreators from '../actions/group-performance-action-creators';

function select(state) {
  return { groupPerformanceStore: state.groupPerformanceStore };
}

class GroupPerformance extends React.Component {
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    groupPerformanceStore: PropTypes.object.isRequired,
  };

  render() {
    const { dispatch, groupPerformanceStore } = this.props;
    const actions = bindActionCreators(groupPerformanceActionCreators, dispatch);
    const {
      people,
      loading,
      canManage,
      examinations,
      editExaminationId,
      examinationResults,
      editStudentProfileId,
      editRowExaminationId,
    } = groupPerformanceStore;

    const {
      toggleEditRow,
      asyncSaveResult,
      asyncDeleteResult,
      openExaminationResultEditor,
    } = actions;

    return (
      <div className="row">
        <GroupPerformanceWidget
          {...{
            people,
            loading,
            canManage,
            examinations,
            toggleEditRow,
            examinationResults,
            editRowExaminationId,
            openExaminationResultEditor,
          }}
        />

        <PerformanceEditor
          {...{
            data: {
              people,
              loading,
              examinations,
              editExaminationId,
              examinationResults,
              editStudentProfileId,
            },
            actions: {
              asyncSaveResult,
              asyncDeleteResult,
            },
          }}
        />
      </div>
    );
  }
}

export default connect(select)(GroupPerformance);
