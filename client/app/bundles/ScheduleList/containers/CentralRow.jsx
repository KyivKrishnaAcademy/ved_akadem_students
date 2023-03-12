import React, { PropTypes } from 'react';

export default class CentralRow extends React.Component {
  static propTypes = {
    visible: PropTypes.bool.isRequired,
    children: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.arrayOf(React.PropTypes.element),
    ]).isRequired,
  };

  render() {
    if (!this.props.visible) { return null; }

    return (
      <tr>
        <td className="central-row" colSpan="7">
          {this.props.children}
        </td>
      </tr>
    );
  }
}
