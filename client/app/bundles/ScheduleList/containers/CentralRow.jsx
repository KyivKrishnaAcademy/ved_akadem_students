import React, { PropTypes } from 'react';

export default class CentralRow extends React.Component {
  static propTypes = {
    visible: PropTypes.bool.isRequired,
  };

  render() {
    if (!this.props.visible) { return <tr/>; }

    return(
      <tr>
        <td className="central-row" colSpan="7">
          {this.props.children}
        </td>
      </tr>
    );
  }
}
