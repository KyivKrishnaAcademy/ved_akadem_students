import React, { PropTypes } from 'react';

import IconButton from '../../../lib/components/bootstrap-icon-button';

const Conditions = ['=', '>', '>=', '<', '<=', '!='];

const ComparableSearch = ({
  defaultValue,
  buttons,
  type,
  isRemovable,
  onRemove,
  fieldName,
  onChangeCondition,
  condition,
  onChange,
}) => {
  let removeButton;

  if (isRemovable) {
    removeButton = (
      <IconButton
        icon="minus"
        size="xs"
        color="danger"
        tooltip={buttons.tooltips.remove}
        onClick={onRemove}
      />
    );
  }

  const conditions = Conditions.map((element) => (
    <li key={element}>
      <a onClick={onChangeCondition(element)}>{element}</a>
    </li>
  ));

  return (
    <div className="ComparableSearch col-xs-12 vert-offset-bottom-1">
      <div className="input-group">
        <span className="input-group-addon">{fieldName}</span>

        <div className="input-group-btn input-group-btn-in-the-middle">
          <button
            type="button"
            className="btn btn-default dropdown-toggle"
            data-toggle="dropdown"
            aria-haspopup="true"
            aria-expanded="false"
          >
            {condition} <span className="caret"></span>
          </button>

          <ul className="dropdown-menu">{conditions}</ul>
        </div>

        <input
          type={type}
          className="form-control"
          onChange={onChange}
          defaultValue={defaultValue}
        />
      </div>

      {removeButton}
    </div>
  );
};

ComparableSearch.propTypes = {
  defaultValue: PropTypes.string.isRequired,
  fieldName: PropTypes.string.isRequired,
  condition: PropTypes.string.isRequired,
  buttons: PropTypes.shape({
    tooltips: PropTypes.shape({
      clear: PropTypes.string.isRequired,
      remove: PropTypes.string.isRequired,
    }).isRequired,
    texts: PropTypes.shape({
      submit: PropTypes.string.isRequired,
    }).isRequired,
  }).isRequired,
  type: PropTypes.oneOf(['number', 'date', 'datetime-local']).isRequired,
  isRemovable: PropTypes.bool.isRequired,
  onRemove: PropTypes.func.isRequired,
  onChange: PropTypes.func.isRequired,
  onChangeCondition: PropTypes.func.isRequired,
};

export default ComparableSearch;
