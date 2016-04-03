import $ from 'jquery'; // eslint-disable-line id-length
import bindAll from '../../../lib/helpers/bind-all';
import Paginator from '../components/Paginator';
import React, { PropTypes } from 'react';
import ScheduleEntry from '../components/ScheduleEntry';

export default class ScheduleList extends React.Component {
  static propTypes = {
    url: PropTypes.string.isRequired,
    headers: PropTypes.array.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    this.state = {
      schedules: [],
      pages: 1,
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
    return $.ajax({
      url,
      dataType: 'json',
      cache: false,
      success: (data) => {
        if (this.mounted) {
          this.setState({
            schedules: data.classSchedules,
            pages: data.pages,
          });
        }
      },

      error: (xhr, status, err) => {
        console.error(this.props.url, status, err.toString()); // eslint-disable-line no-console
      },
    });
  }

  render() {
    const schedules = this.state.schedules.map((schedule) =>
      <ScheduleEntry key={schedule.id} schedule={schedule} />
    );

    const headers = this.props.headers.map((header) =>
      <th key={header}>{header}</th>
    );

    return (
      <div className="row">
        <div className="col-xs-12">
          <div className="table-responsive">
            <table className="table table-condensed table-striped">
              <thead>
                <tr>
                  {headers}
                </tr>
              </thead>
              <tbody>
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
