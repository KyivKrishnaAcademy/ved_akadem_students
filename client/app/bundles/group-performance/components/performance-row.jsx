import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';
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
    examinationResults: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number.isRequired,
      score: PropTypes.number.isRequired,
      personId: PropTypes.number.isRequired,
      examinationId: PropTypes.number.isRequired,
    })).isRequired,
    toggleEditRow: PropTypes.func.isRequired,
    editRowExaminationId: PropTypes.number.isRequired,
    openExaminationResultEditor: PropTypes.func.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    bindAll(this, 'toggleEditRow');
  }

  toggleEditRow() {
    this.props.toggleEditRow(this.props.examination.id);
  }

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
        status={examinationResults[personId] && examinationResults[personId].presence}
        personId={personId}
        examinationId={examination.id}
        isEditExamination={editRowExaminationId === examination.id}
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
