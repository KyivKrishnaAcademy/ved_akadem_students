import React from 'react';
import { Provider } from 'react-redux';

import createStore from '../store/certificate-assignments-store';
import CertificateAssignments from '../containers/certificate-assignments';

// See documentation for https://github.com/reactjs/react-redux.
// This is how you get props from the Rails view into the redux store.
// This code here binds your smart component to the redux store.
export default (props) => {
  const store = createStore(props);
  const reactComponent = (
    <Provider store={store}>
      <CertificateAssignments />
    </Provider>
  );
  return reactComponent;
};
