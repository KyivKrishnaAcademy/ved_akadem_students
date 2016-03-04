import React, { PropTypes } from 'react';
import ReactPaginate from 'react-paginate-component';

const Paginator = ({ maxPages, onChangePage }) => {
  if (maxPages <= 1) { return <div />; }

  let maxVisible;

  if (maxPages < 5) {
    maxVisible = maxPages;
  } else {
    maxVisible = 5;
  }

  return (
    <div className="col-xs-12 text-center">
      <ReactPaginate max={maxPages}
        maxVisible={maxVisible}
        onChange={onChangePage}
        className="pagination-sm"
      />
    </div>
  );
};

Paginator.propTypes = {
  maxPages: PropTypes.number.isRequired,
  onChangePage: PropTypes.func.isRequired,
};

export default Paginator;
