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
      editPersonId,
      examinations,
      editExaminationId,
      examinationResults,
      editRowExaminationId,
    } = groupPerformanceStore;

    const {
      toggleEditRow,
      openExaminationResultEditor,
    } = actions;

    return (
      <div className="row">
        <GroupPerformanceWidget
          {...{
            people,
            loading,
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
              editPersonId,
              examinations,
              editExaminationId,
              examinationResults,
            },
          }}
        />
      </div>
    );
  }
}

export default connect(select)(GroupPerformance);
