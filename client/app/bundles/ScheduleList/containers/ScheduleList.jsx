import $ from 'jquery'; // eslint-disable-line id-length
import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';

import Loader from '../components/Loader';
import Paginator from '../components/Paginator';
import CentralRow from './CentralRow';
import ScheduleEntry from '../components/ScheduleEntry';
import TimesSelector from '../components/TimesSelector';

export default class ScheduleList extends React.Component {
  static propTypes = {
    url: PropTypes.string.isRequired,
    headers: PropTypes.array.isRequired,
    noSchedules: PropTypes.string.isRequired,
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
    return `${this.props.url}?page=${this.state.currentPage}&direction=${this.state.direction}`
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
    const showSchedules = !this.state.loading && this.state.schedules.length === 0;

    const schedules = this.state.schedules.map((schedule) =>
      <ScheduleEntry key={schedule.id} schedule={schedule} />
    );

    const headers = this.props.headers.map((header) =>
      <th key={header}>{header}</th>
    );

    return (
      <div className="row classSchedule">
        <div className="col-xs-12">
          <TimesSelector
            onChange={direction => () => this._updateSchedules(1, direction)}
            direction={this.state.direction}
          />
        </div>

        <div className="col-xs-12">
          <Loader visible={this.state.loading} />

          <div className="table-responsive">
            <table className="table table-condensed table-striped">
              <thead>
                <tr>
                  {headers}
                </tr>
              </thead>
              <tbody>
                <CentralRow visible={showSchedules}>
                  {this.props.noSchedules}
                </CentralRow>

                {schedules}
              </tbody>
            </table>
          </div>
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
