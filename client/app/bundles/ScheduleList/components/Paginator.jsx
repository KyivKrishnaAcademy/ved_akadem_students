import React, { PropTypes } from 'react';
import ReactPaginate from '../containers/Paginate';

const Paginator = ({ maxPages, direction, onChangePage }) => {
  if (maxPages <= 1) { return <div />; }

  let maxVisible;

  if (maxPages < 5) {
    maxVisible = maxPages;
  } else {
    maxVisible = 5;
  }

  return (
    <div className="col-xs-12 text-center">
      <ReactPaginate
        max={maxPages}
        onChange={onChangePage}
        className="pagination-sm"
        maxVisible={maxVisible}
        versionedNullifier={direction}
      />
    </div>
  );
};

Paginator.propTypes = {
  maxPages: PropTypes.number.isRequired,
  direction: PropTypes.string.isRequired,
  onChangePage: PropTypes.func.isRequired,
};

export default Paginator;
