import $ from 'jquery'; // eslint-disable-line id-length
import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';

import Loader from '../components/Loader';
import Paginator from '../components/Paginator';
import TimesSelector from '../components/TimesSelector';
import SchedulesTable from '../components/SchedulesTable';

export default class ScheduleList extends React.Component {
  static propTypes = {
    url: PropTypes.string.isRequired,
    headers: PropTypes.array.isRequired,
    noSchedules: PropTypes.string.isRequired,
    hideDirections: PropTypes.bool,
  };

  constructor(props, context) {
    super(props, context);

    this.state = {
      pages: 1,
      loading: true,
      direction: 'future',
      schedules: [],
      currentPage: 1,
    };

    bindAll(this, '_updateSchedules');
  }

  componentDidMount() {
    this.mounted = true;

    return this._updateSchedules();
  }

  componentWillUnmount() {
    this.mounted = false;
  }

  _computedUrl() {
    const url = `${this.props.url}?page=${this.state.currentPage}`;

    return this.props.hideDirections ? url : `${url}&direction=${this.state.direction}`;
  }

  _updateSchedules(page, direction) {
    this.setState(
      (prevState, props) => ({
        loading: true,
        direction: direction || prevState.direction,
        currentPage: page || prevState.currentPage,
      }),
      () => $.ajax({
        url: this._computedUrl(),
        dataType: 'json',
        cache: false,
        success: (data) => {
          if (this.mounted) {
            this.setState({
              pages: data.pages,
              loading: false,
              schedules: data.classSchedules,
            });
          }
        },

        error: (xhr, status, err) => {
          console.error(this._computedUrl(), status, err.toString()); // eslint-disable-line no-console

          this.setState({ loading: false });
        },
      })
    );
  }

  render() {
    const onTimeSelect = direction => () => this._updateSchedules(1, direction);
    const timeSelector = (
      <div className="col-xs-12 vert-offset-bottom-1">
        <TimesSelector
          onChange={onTimeSelect}
          direction={this.state.direction}
        />
      </div>
    );

    return (
      <div className="row classSchedule">
        {this.props.hideDirections ? null : timeSelector}

        <div className="col-xs-12">
          <Loader visible={this.state.loading} />

          <SchedulesTable
            headers={this.props.headers}
            loading={this.state.loading}
            schedules={this.state.schedules}
            noSchedules={this.props.noSchedules}
          />
        </div>

        <Paginator
          maxPages={this.state.pages}
          direction={this.state.direction}
          onChangePage={this._updateSchedules}
        />
      </div>
    );
  }
}
