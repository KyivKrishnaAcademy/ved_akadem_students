import React from 'react';
import LinkOrText from './LinkOrText';

const LectorLinkOrText = ({ lector }) => {
  if (lector) {
    return (
      <LinkOrText
        condition={lector.canView}
        path={lector.path}
        text={lector.complexName}
      />
    );
  }

  return <span />;
};

export default LectorLinkOrText;
