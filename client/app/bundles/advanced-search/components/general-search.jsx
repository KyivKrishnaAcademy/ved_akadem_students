import React, { PropTypes } from 'react';

import IconButton from '../../../lib/components/bootstrap-icon-button';

const GeneralSearch = ({
  defaultValue,
  buttons,
  isRemovable,
  onRemove,
  placeholder,
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
    <div className="GeneralSearch col-xs-12 vert-offset-bottom-1">
      <input
        type="text"
        className="form-control"
        placeholder={placeholder}
        onChange={onChange}
        defaultValue={defaultValue}
      />

      {removeButton}
    </div>
  );
};

GeneralSearch.propTypes = {
  defaultValue: PropTypes.string.isRequired,
  placeholder: PropTypes.string.isRequired,
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

export default GeneralSearch;
