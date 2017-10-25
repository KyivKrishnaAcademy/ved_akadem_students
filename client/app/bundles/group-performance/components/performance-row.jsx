import React, { PropTypes } from 'react';

import Button from '../../../lib/components/bootstrap-button';
import PerformanceMarker from './performance-marker';

export default class PerformanceRow extends React.Component {
  static propTypes = {
    peopleIds: PropTypes.arrayOf(PropTypes.number).isRequired,
    examination: PropTypes.shape({
      id: PropTypes.number.isRequired,
      title: PropTypes.string.isRequired,
      maxResult: PropTypes.number.isRequired,
      minResult: PropTypes.number.isRequired,
      courseTitle: PropTypes.string.isRequired,
      description: PropTypes.string.isRequired,
      passingScore: PropTypes.number.isRequired,
    }).isRequired,
    examinationResults: PropTypes.object.isRequired,
    toggleEditRow: PropTypes.func.isRequired,
    editRowExaminationId: PropTypes.number.isRequired,
    openExaminationResultEditor: PropTypes.func.isRequired,
  };

  toggleEditRow = () => this.props.toggleEditRow(this.props.examination.id);

  render() {
    const {
      peopleIds,
      examination,
      examinationResults,
      editRowExaminationId,
      openExaminationResultEditor,
      examination: {
        title,
        courseTitle,
      },
    } = this.props;

    const performanceMarkers = peopleIds.map(personId =>
      <PerformanceMarker
        key={personId}
        score={examinationResults[personId] && examinationResults[personId].score}
        personId={personId}
        examinationId={examination.id}
        isEditExamination={editRowExaminationId === examination.id}
        examinationPassingScore={examination.passingScore}
        openExaminationResultEditor={openExaminationResultEditor}
      />
    );

    const editButton = true // canManage
    ?
      <Button
        icon="pencil"
        subClass="primary"
        onClick={this.toggleEditRow}
      />
    : null;

    return (
      <div className="scrollable-row">
        <div className="scrollable-header">
          <div className="pivoted-content vert-offset-bottom-1">
            <span>{title}</span>
            <br/>
            <b>{courseTitle}</b>
          </div>

          {editButton}
        </div>

        {performanceMarkers}
      </div>
    );
  }
}
