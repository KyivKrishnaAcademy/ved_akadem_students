import React from 'react';
import ReactPaginate from 'react-paginate-component';

export default class Paginate extends ReactPaginate {
  static propTypes = {
    max: React.PropTypes.number.isRequired,
    onChange: React.PropTypes.func.isRequired,
    maxVisible: React.PropTypes.number,
    versionedNullifier: React.PropTypes.any,
  };

  componentWillReceiveProps(nextProps) {
    if (nextProps.versionedNullifier !== this.props.versionedNullifier) {
      this.setState({ currentPage: 1 });
    }
  }

  componentDidUpdate(prevProps, prevState) {
    const isSameVersion = prevProps.versionedNullifier === this.props.versionedNullifier;

    if (prevState.currentPage !== this.state.currentPage && isSameVersion) {
      this.props.onChange(this.state.currentPage);
    }
  }
}
