import $ from 'jquery'; // eslint-disable-line id-length
import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';

import Paginator from '../components/Paginator';
import CentralRow from './CentralRow';
import ScheduleEntry from '../components/ScheduleEntry';

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
      schedules: [],
    };

    bindAll(this, '_onChangePage');
  }

  componentDidMount() {
    this.mounted = true;

    return this._updateSchedules(this.props.url);
  }

  componentWillUnmount() {
    this.mounted = false;
  }

  _onChangePage(page) {
    return this._updateSchedules(`${this.props.url}?page=${page}`);
  }

  _updateSchedules(url) {
    this.setState({ loading: true });

    return $.ajax({
      url,
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
        console.error(this.props.url, status, err.toString()); // eslint-disable-line no-console

        this.setState({ loading: false });
      },
    });
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
          <div className="table-responsive">
            <table className="table table-condensed table-striped">
              <thead>
                <tr>
                  {headers}
                </tr>
              </thead>
              <tbody>
                <CentralRow visible={this.state.loading}>
                  <i className="fa fa-refresh fa-spin fa-3x fa-fw" />

                  <span className="sr-only">Loading...</span>
                </CentralRow>

                <CentralRow visible={showSchedules}>
                  {this.props.noSchedules}
                </CentralRow>

                {schedules}
              </tbody>
            </table>
          </div>
        </div>

        <Paginator maxPages={this.state.pages} onChangePage={this._onChangePage} />
      </div>
    );
  }
}
