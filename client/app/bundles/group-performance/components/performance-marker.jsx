import React, { PropTypes } from 'react';

import Button from '../../../lib/components/bootstrap-button';

const PerformanceMarker = ({
  score,
  personId,
  examinationId,
  isEditExamination,
  examinationPassingScore,
  openExaminationResultEditor,
}) => {
  const openEditor = () => openExaminationResultEditor(personId, examinationId);

  let content = '\u00A0';
  let cellClass = 'cell editable-cell';
  let buttonClass = 'default';

  if (score !== undefined && score >= examinationPassingScore) {
    content = <span className="glyphicon glyphicon-ok" />;
    cellClass = 'cell bg-success editable-cell';
    buttonClass = 'success';
  } else if (score !== undefined && score < examinationPassingScore) {
    content = <span className="glyphicon glyphicon-remove" />;
    cellClass = 'cell bg-danger editable-cell';
    buttonClass = 'danger';
  }

  const button = isEditExamination ?
    <Button
      icon="pencil"
      onClick={openEditor}
      subClass={buttonClass}
    />
  :
    null;

  return <div className={cellClass}>{button || content}</div>;
};

PerformanceMarker.propTypes = {
  score: PropTypes.number,
  personId: PropTypes.number.isRequired,
  examinationId: PropTypes.number.isRequired,
  isEditExamination: PropTypes.bool.isRequired,
  examinationPassingScore: PropTypes.number.isRequired,
  openExaminationResultEditor: PropTypes.func.isRequired,
};

export default PerformanceMarker;
