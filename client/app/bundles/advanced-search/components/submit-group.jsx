import React, { PropTypes } from 'react';

const SubmitGroup = ({ submitLabel, submitLinkPath, newFilterOptions }) => {
  const options = newFilterOptions.map(({ title, onClick }) => (
    <li key={title}>
      <a onClick={onClick}>{title}</a>
    </li>
  ));

  return (
    <div className="SubmitGroup col-xs-12">
      <div className="btn-group btn-group-lg" role="group">
        <div className="btn-group btn-group-lg" role="group">
          <button
            type="button"
            className="btn btn-primary dropdown-toggle"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
          >
            <span className="glyphicon glyphicon-plus" aria-hidden="true" />
          </button>

          <ul className="dropdown-menu">{options}</ul>
        </div>

        <a
          href={submitLinkPath}
          type="button"
          className="btn btn-primary submit"
        >
          {submitLabel}
        </a>
      </div>
    </div>
  );
};

SubmitGroup.propTypes = {
  submitLabel: PropTypes.string.isRequired,
  submitLinkPath: PropTypes.string.isRequired,
  newFilterOptions: PropTypes.arrayOf(
    PropTypes.shape({
      title: PropTypes.string.isRequired,
      onClick: PropTypes.func.isRequired,
    })
  ).isRequired,
};

export default SubmitGroup;
