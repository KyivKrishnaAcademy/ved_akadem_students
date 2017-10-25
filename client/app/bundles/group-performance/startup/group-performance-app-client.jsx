import React from 'react';
import { Provider } from 'react-redux';

import createStore from '../store/group-performance-store';
import GroupPerformance from '../containers/group-performance';

export default (props) => {
  const store = createStore(props);

  const reactComponent = (
    <Provider store={store}>
      <GroupPerformance />
    </Provider>
  );

  return reactComponent;
};
