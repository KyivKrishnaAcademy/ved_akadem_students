import React, { PropTypes } from 'react';

const cellClass = (value) => {
  if (value >= 82) return 'bg-success';
  if (value >= 66) return 'bg-warning';

  return 'bg-danger';
};

export default class StatisticsRow extends React.Component {
  static propTypes = {
    peopleIds: PropTypes.arrayOf(PropTypes.number).isRequired,
    classSchedules: PropTypes.arrayOf(PropTypes.shape({
      attendances: PropTypes.object.isRequired,
    })).isRequired,
  };

  render() {
    const { peopleIds, classSchedules } = this.props;

    const statsticsCells = [];

    peopleIds.forEach(personId => {
      let negativeCount = 0;
      let positiveCount = 0;

      classSchedules.forEach(classSchedule => {
        const attendance = classSchedule.attendances[personId];

        if (attendance && attendance.presence) {
          positiveCount++;
        } else if (attendance && !attendance.presence) {
          negativeCount++;
        }
      });

      const total = positiveCount + negativeCount;

      if (total) {
        const percentage = positiveCount ? 100 / total * positiveCount : 0;
        const className = `cell ${cellClass(percentage)}`;

        statsticsCells.push(<div className={className} key={personId}>{percentage}%</div>);
      } else {
        statsticsCells.push(<div className="cell" key={personId}>{'\u00A0'}</div>);
      }
    });

    return (
      <div className="scrollable-row">
        <div className="scrollable-header"/>

        {statsticsCells}
      </div>
    );
  }
}
