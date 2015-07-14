var SchedulesTable = React.createClass({
  propTypes: {
    url: React.PropTypes.string.isRequired,
    headers: React.PropTypes.array.isRequired
  },

  getInitialState: function() {
    return {
      schedules: [],
      pages: 1
    }
  },

  componentDidMount: function() {
    return this._updateSchedules(this.props.url);
  },

  _onChangePage: function(page) {
    return this._updateSchedules(this.props.url + '?page=' + page);
  },

  _updateSchedules: function(url) {
    return $.ajax({
      url: url,
      dataType: 'json',
      cache: false,
      success: function(data) {
        if (this.isMounted()) {
          this.setState({
            schedules: data.class_schedules,
            pages: data.pages
          });
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  _paginator: function(maxPages, onChange) {
    if (maxPages > 1) {
      var maxVisible;

      if (maxPages < 5) {
        maxVisible = maxPages;
      } else {
        maxVisible = 5;
      }

      return(
        <div className="col-xs-12 text-center">
          <Paginator max={maxPages}
            maxVisible={maxVisible}
            onChange={onChange}
            className={"pagination-sm"} />
        </div>
      );
    }
  },

  render: function() {
    var schedules = this.state.schedules.map(function(schedule) {
      return(<Schedule key={schedule.id} schedule={schedule} />);
    });

    var headers = this.props.headers.map(function(header) {
      return <th key={header}>{header}</th>;
    });

    return(
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
});
