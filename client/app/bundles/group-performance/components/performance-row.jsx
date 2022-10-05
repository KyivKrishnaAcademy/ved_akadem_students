import React, { PropTypes } from 'react';

import IconButton from '../../../lib/components/bootstrap-icon-button';
import PerformanceMarker from './performance-marker';

export default class PerformanceRow extends React.Component {
  static propTypes = {
    canManage: PropTypes.bool.isRequired,
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
      canManage,
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

    const editButton = canManage
    ?
      <IconButton
        size="sm"
        icon="pencil"
        color="primary"
        onClick={this.toggleEditRow}
      />
    : null;

    return (
      <div className="scrollable-row">
        <div className="scrollable-header">
          <div className="pivoted-content vert-offset-bottom-1">
            <b>{title}</b>
            <br/>
            <span>{courseTitle}</span>
          </div>

          {editButton}
        </div>

        {performanceMarkers}
      </div>
    );
  }
}
