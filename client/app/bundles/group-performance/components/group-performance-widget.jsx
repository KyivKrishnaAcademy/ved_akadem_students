import React, { PropTypes } from 'react';

import Loader from '../../../lib/components/loader';
import PerformanceRow from './performance-row';

export default class GroupPerformanceWidget extends React.Component {
  static propTypes = {
    people: PropTypes.arrayOf(PropTypes.shape({
      name: PropTypes.string.isRequired,
    })).isRequired,
    loading: PropTypes.bool.isRequired,
    examinations: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number.isRequired,
      title: PropTypes.string.isRequired,
      maxResult: PropTypes.number.isRequired,
      minResult: PropTypes.number.isRequired,
      courseTitle: PropTypes.string.isRequired,
      description: PropTypes.string.isRequired,
      passingScore: PropTypes.number.isRequired,
    })).isRequired,
    toggleEditRow: PropTypes.func.isRequired,
    examinationResults: PropTypes.object.isRequired,
    editRowExaminationId: PropTypes.number.isRequired,
    openExaminationResultEditor: PropTypes.func.isRequired,
  };

  componentDidUpdate() {
    window.adjustAttendanceHeaders('.scrollable-header');
    window.adjustAttendanceHeaders('.editable-cell');
  }

  render() {
    const {
      people,
      loading,
      examinations,
      toggleEditRow,
      examinationResults,
      editRowExaminationId,
      openExaminationResultEditor,
    } = this.props;

    const peopleIds = people.map(person => person.studentProfileId);
    const peopleNames = people.map(person =>
      <div className="cell editable-cell person-name" key={person.name}>{person.name}</div>
    );

    const performanceRows = examinations.map((examination, index) =>
      <PerformanceRow
        key={index}
        peopleIds={peopleIds}
        examination={examination}
        toggleEditRow={toggleEditRow}
        examinationResults={examinationResults[examination.id]}
        editRowExaminationId={editRowExaminationId}
        openExaminationResultEditor={openExaminationResultEditor}
      />
    );

    return (
      <div className="groupScrollableTable col-xs-12 vert-offset-top-1 vert-offset-bottom-3">
        <Loader visible={loading} />

        <div className="scrollable-row">
          <div className="scrollable-header" />

          {peopleNames}
        </div>

        <div className="scrollable-rows">
          {performanceRows}
        </div>
      </div>
    );
  }
}
