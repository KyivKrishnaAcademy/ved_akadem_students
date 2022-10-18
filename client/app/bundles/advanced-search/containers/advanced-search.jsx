import qs from 'qs';
import pipe from 'pipe-functions';
import React, { PropTypes } from 'react';

import bindAll from '../../../lib/helpers/bind-all';

import SubmitGroup from '../components/submit-group';
import GeneralSearch from '../components/general-search';
import TextSearch from '../components/text-search';
import ComparableSearch from '../components/comparable-search';

export default class AdvancedSearch extends React.Component {
  static propTypes = {
    filters: PropTypes.objectOf(
      PropTypes.shape({
        type: PropTypes.oneOf([
          'general-search',
          'text',
          'number',
          'date',
          'datetime-local',
        ]).isRequired,
        title: PropTypes.string.isRequired,
        isMultiple: PropTypes.bool.isRequired,
        isRemovable: PropTypes.bool.isRequired,
        isRenderOnStart: PropTypes.bool.isRequired,
      })
    ).isRequired,
    buttons: PropTypes.shape({
      tooltips: PropTypes.shape({
        clear: PropTypes.string.isRequired,
        remove: PropTypes.string.isRequired,
      }).isRequired,
      texts: PropTypes.shape({
        submit: PropTypes.string.isRequired,
      }).isRequired,
    }).isRequired,
  };

  constructor(props, context) {
    super(props, context);

    bindAll(
      this,
      '_addFilter',
      '_changeCondition',
      '_initDefaultFilters',
      '_newFilterOptions',
      '_onValueChange',
      '_removeFilter',
      '_shownFilters',
    );

    this.state = pipe({}, this._initUrlParams, this._initDefaultFilters);
  }

  _initUrlParams(state) {
    const location = window.location;
    const pathname = location.pathname;
    const urlQuery = qs.parse(location.search.split('?').pop());

    return { ...state, pathname, urlQuery };
  }

  _initDefaultFilters(state) {
    const config = this.props.filters;
    const searchQuery = state.urlQuery.search || [];
    const searchState = {};
    const firstValues = Object.fromEntries(
      searchQuery
        .reverse()
        .map(({ condition, field, type, value }) => [
          `${field}-${type}`,
          { value, condition },
        ])
    );

    Object.entries(config).every(
      ([field, { type, isRenderOnStart }], index) => {
        if (isRenderOnStart) {
          const key = `${field}-${type}`;
          const firstValue = {
            ...{ value: '', condition: '=' },
            ...(firstValues[key] || {}),
          };
          const { value, condition } = firstValue;

          searchState[index] = { field, type, value, condition };
        }

        return true;
      }
    );

    const nextIndex = this._nextFilterIndex(searchState);
    const initializedFilters = Object.fromEntries(
      Object.values(searchState).map(({ condition, field, type, value }) => [
        `${field}-${type}-${condition}-${value}`,
        true,
      ])
    );

    searchQuery.every(({ condition, field, type, value }, index) => {
      const initializedKey = `${field}-${type}-${condition}-${value}`;
      const isInitialized = initializedFilters[initializedKey];
      const filterConfig = config[field];

      if (filterConfig && !isInitialized) {
        searchState[nextIndex + index] = {
          type: filterConfig.type,
          field,
          value,
          condition,
        };
      }

      return true;
    });

    return { ...state, search: searchState };
  }

  _shownFilters() {
    const searchState = this.state.search;
    const configs = this.props.filters;

    // Skipping gaps in the ids series
    return this._sortedSearchKeys(searchState).map((id) => {
      const searchEntry = searchState[id];
      const { field, type, value, condition } = searchEntry;
      const { title, isRemovable } = configs[field];

      switch (type) {
        case 'general-search':
          return (
            <GeneralSearch
              key={id}
              buttons={this.props.buttons}
              isRemovable={isRemovable}
              onRemove={this._removeFilter(id)}
              onChange={this._onValueChange(id)}
              placeholder={title}
              defaultValue={value}
            />
          );
        case 'text':
          return (
            <TextSearch
              key={id}
              buttons={this.props.buttons}
              isRemovable={isRemovable}
              onRemove={this._removeFilter(id)}
              onChange={this._onValueChange(id)}
              fieldName={title}
              defaultValue={value}
            />
          );
        case 'number':
        case 'date':
        case 'datetime-local':
          return (
            <ComparableSearch
              key={id}
              buttons={this.props.buttons}
              type={type}
              isRemovable={isRemovable}
              onRemove={this._removeFilter(id)}
              onChangeCondition={this._changeCondition(id)}
              onChange={this._onValueChange(id)}
              fieldName={title}
              condition={condition}
              defaultValue={value}
            />
          );
        default:
          throw new Error(`Unknown component type: ${type}.`);
      }
    });
  }

  _newFilterOptions() {
    const searchState = this.state.search;
    const configs = this.props.filters;
    const existingFilters = Object.values(searchState).reduce((acc, { field }) => ({ ...acc, [field]: true }), {});

    return Object.keys(configs).reduce((acc, id) => {
      const newAcc = acc;
      const { title, isMultiple } = configs[id];

      if (isMultiple || !existingFilters[id]) newAcc.push({ title, onClick: this._addFilter(id) });

      return newAcc;
    }, []);
  }

  _sortedSearchKeys(searchState) {
    return Object.keys(searchState)
      .map((key) => parseInt(key, 10))
      .sort((left, right) => {
        if (left > right) return 1;
        if (left < right) return -1;
        return 0;
      });
  }

  _nextFilterIndex(searchState) {
    let nextIndex = this._sortedSearchKeys(searchState).pop();

    return ++nextIndex;
  }

  _addFilter(field) {
    const state = this.state;
    const searchState = state.search;
    const configs = this.props.filters;

    return () => {
      const nextIndex = this._nextFilterIndex(searchState);
      const type = configs[field].type;
      searchState[nextIndex] = { field, type, value: '', condition: '=' };

      this.setState({ ...state, search: searchState });
    };
  }

  _removeFilter(id) {
    const state = this.state;
    const searchState = state.search;

    return () => {
      const { ...newSearchState } = searchState;

      delete newSearchState[id];

      this.setState({ ...state, search: newSearchState });
    };
  }

  _changeCondition(id) {
    const state = this.state;
    const searchState = state.search;

    return (condition) => () => {
      searchState[id].condition = condition;

      this.setState({ ...state, search: searchState });
    };
  }

  _onValueChange(id) {
    const state = this.state;
    const searchState = state.search;

    return (event) => {
      searchState[id].value = event.target.value;

      this.setState({ ...state, search: searchState });
    };
  }

  _pruneSearchParams(search) {
    return Object.values(search)
      .reduce((acc, element) => {
        const value =
          element.value === null || element.value === undefined
            ? ''
            : element.value;

        if (typeof value === 'string' && value.trim().length === 0) return acc;

        return [...acc, element];
      }, [])
      .reverse();
  }

  _constructLinkPath(pathname, urlQuery, search) {
    const newQueryString = qs.stringify({ ...urlQuery, search });

    return pathname.concat('?', newQueryString);
  }

  render() {
    const shownFilters = this._shownFilters();
    const newFilterOptions = this._newFilterOptions();
    const prunedSearch = this._pruneSearchParams(this.state.search);
    const submitLinkPath = this._constructLinkPath(
      this.state.pathname,
      this.state.urlQuery,
      prunedSearch
    );

    return (
      <div className="AdvancedSearch row">
        {shownFilters}

        <SubmitGroup
          submitLinkPath={submitLinkPath}
          submitLabel={this.props.buttons.texts.submit}
          newFilterOptions={newFilterOptions}
        />
      </div>
    );
  }
}
