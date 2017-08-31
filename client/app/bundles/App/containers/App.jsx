import PropTypes from 'prop-types';
import React from 'react';
import SeasonIndex from '../components/seasons/Index';

export default class App extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let seasons = JSON.parse(this.props.seasons);
    return (
      <div>
        <SeasonIndex seasons={seasons} />
      </div>
    );
  }
}
