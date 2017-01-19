import React, { PropTypes } from 'react';

const TimesSelector = ({ onChange, direction }) => (
  <div className="btn-group" role="group" aria-label="...">
    <a
      type="button"
      onClick={onChange('past')}
      className={'btn btn-sm btn-info' + (direction === 'past' ? ' active' : '')}
    >
      <span className="glyphicon glyphicon-backward" aria-hidden="true"/>
      &nbsp;&nbsp;
      <span className="glyphicon glyphicon-hourglass" aria-hidden="true"/>
    </a>

    <a
      type="button"
      onClick={onChange('future')}
      className={'btn btn-sm btn-info' + (direction === 'future' ? ' active' : '')}
    >
      <span className="glyphicon glyphicon-hourglass" aria-hidden="true"/>
      &nbsp;&nbsp;
      <span className="glyphicon glyphicon-forward" aria-hidden="true"/>
    </a>
  </div>
);

TimesSelector.propTypes = {
  onChange: PropTypes.func.isRequired,
  direction: PropTypes.string.isRequired,
};

export default TimesSelector;
