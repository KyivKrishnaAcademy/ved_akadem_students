import React, { PropTypes } from 'react';

import Button from '../../../lib/components/bootstrap-button';

const PerformanceMarker = ({ status, personId, examinationId, isEditExamination, openExaminationResultEditor }) => {
  const openEditor = () => openExaminationResultEditor(personId, examinationId);

  const button = isEditExamination ?
    <Button
      icon="pencil"
      subClass="primary"
      onClick={openEditor}
    />
  :
    null;

  if (status === true) {
    const content = <span className="glyphicon glyphicon-ok" />;

    return <div className="cell bg-success">{button || content}</div>;
  }

  if (status === false) {
    const content = <span className="glyphicon glyphicon-remove" />;

    return <div className="cell bg-danger">{button || content}</div>;
  }

  return <div className="cell editable-cell">{button || '\u00A0'}</div>;
};

PerformanceMarker.propTypes = {
  status: PropTypes.bool,
  personId: PropTypes.number.isRequired,
  examinationId: PropTypes.number.isRequired,
  isEditExamination: PropTypes.bool.isRequired,
  openExaminationResultEditor: PropTypes.func.isRequired,
};

export default PerformanceMarker;
