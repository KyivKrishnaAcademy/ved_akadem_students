import React, { PropTypes } from 'react';
import ReactPaginate from 'react-paginate-component';

export default class Paginate extends ReactPaginate {
  static propTypes = {
    max: PropTypes.number.isRequired,
    onChange: PropTypes.func.isRequired,
    maxVisible: PropTypes.number,
    versionedNullifier: PropTypes.any,
  };

  componentWillReceiveProps(nextProps) {
    if (nextProps.versionedNullifier !== this.props.versionedNullifier) {
      this.setState({ currentPage: 1 })
    }
  }

  componentDidUpdate(prevProps, prevState) {
    const isSameVersion = prevProps.versionedNullifier === this.props.versionedNullifier;

    if (prevState.currentPage !== this.state.currentPage && isSameVersion) {
      this.props.onChange(this.state.currentPage);
    }
  }
}
