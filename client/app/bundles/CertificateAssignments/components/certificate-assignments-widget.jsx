import React, { PropTypes } from 'react';
import bindAll from '../../../lib/helpers/bind-all';
import { Input } from 'react-bootstrap';

export default class CertificateAssignmentsWidget extends React.Component {
  static propTypes = {
    // If you have lots of data or action properties, you should consider grouping them by
    // passing two properties: "data" and "actions".
    updateName: PropTypes.func.isRequired,
    name: PropTypes.string.isRequired,
  };

  constructor(props, context) {
    super(props, context);

    bindAll(this, 'handleChange');
  }

  // React will automatically provide us with the event `e`
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
        <form className="form-horizontal">
            <Input
              type="text"
              labelClassName="col-sm-2"
              wrapperClassName="col-sm-10"
              label="Say hello to:"
              value={name}
              onChange={this.handleChange}
            />
        </form>
      </div>
    );
  }
}
