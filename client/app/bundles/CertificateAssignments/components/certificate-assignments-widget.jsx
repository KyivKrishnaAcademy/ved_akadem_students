import React, { PropTypes } from 'react';
import bindAll from '../../../lib/helpers/bind-all';

export default class CertificateAssignmentsWidget extends React.Component {
  static propTypes = {
    updateName: PropTypes.func.isRequired,
    name: PropTypes.string.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    bindAll(this, 'handleChange');
  }

  handleChange(e) {
    const name = e.target.value;
    this.props.updateName(name);
  }

  render() {
    const { name } = this.props;
    return (
      <div className="container">
        <h3>
          Hello, {name}!
        </h3>
        <hr/>
        <input
          type="text"
          value={name}
          onChange={this.handleChange}
        />
      </div>
    );
  }
}
