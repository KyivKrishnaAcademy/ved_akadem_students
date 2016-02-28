import $ from 'jquery'; // eslint-disable-line id-length
import bindAll from '../../../lib/helpers/bindAll';
import Paginator from 'react-paginate-component';
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

  _paginator(maxPages, onChange) {
    if (maxPages > 1) {
      let maxVisible;

      if (maxPages < 5) {
        maxVisible = maxPages;
      } else {
        maxVisible = 5;
      }

      return (
        <div className="col-xs-12 text-center">
          <Paginator max={maxPages}
            maxVisible={maxVisible}
            onChange={onChange}
            className="pagination-sm"
          />
        </div>
      );
    }
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

        {this._paginator(this.state.pages, this._onChangePage)}
      </div>
    );
  }
}
