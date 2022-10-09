import React, { PropTypes } from 'react';

import IconButton from '../../../lib/components/bootstrap-icon-button';

const TextSearch = ({
  defaultValue,
  buttons,
  isRemovable,
  onRemove,
  fieldName,
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

  return (
    <div className="TextSearch col-xs-12 vert-offset-bottom-1">
      <div className="input-group">
        <span className="input-group-addon">{fieldName}</span>

        <input
          type="text"
          className="form-control"
          onChange={onChange}
          defaultValue={defaultValue}
        />
      </div>

      {removeButton}
    </div>
  );
};

TextSearch.propTypes = {
  defaultValue: PropTypes.string.isRequired,
  fieldName: PropTypes.string.isRequired,
  buttons: PropTypes.shape({
    tooltips: PropTypes.shape({
      clear: PropTypes.string.isRequired,
      remove: PropTypes.string.isRequired,
    }).isRequired,
    texts: PropTypes.shape({
      submit: PropTypes.string.isRequired,
    }).isRequired,
  }).isRequired,
  isRemovable: PropTypes.bool.isRequired,
  onRemove: PropTypes.func.isRequired,
  onChange: PropTypes.func.isRequired,
};

export default TextSearch;
