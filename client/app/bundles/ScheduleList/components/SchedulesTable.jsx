import React, { PropTypes } from 'react';

import CentralRow from '../containers/CentralRow';
import ScheduleEntry from './ScheduleEntry';

const SchedulesTable = ({ headers, loading, schedules, noSchedules }) => {
  const showSchedules = !loading && schedules.length === 0;

  const scheduleEntries = schedules.map((schedule) =>
    <ScheduleEntry key={schedule.id} schedule={schedule} />
  );

  const composedHeaders = headers.map((header) =>
    <th key={header}>{header}</th>
  );

  return (
    <div className="table-responsive">
      <table className="table table-condensed table-striped">
        <thead>
          <tr>
            {composedHeaders}
          </tr>
        </thead>
        <tbody>
          <CentralRow visible={showSchedules}>
            {noSchedules}
          </CentralRow>

          {scheduleEntries}
        </tbody>
      </table>
    </div>
  );
};

SchedulesTable.propTypes = {
  headers: PropTypes.array.isRequired,
  loading: PropTypes.bool.isRequired,
  schedules: PropTypes.array.isRequired,
  noSchedules: PropTypes.string.isRequired,
};

export default SchedulesTable;
