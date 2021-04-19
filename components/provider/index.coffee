import React      from "react"
import PropTypes  from "prop-types"
import cx         from "classnames"

import './styles'

export default \
class Provider extends React.Component
  @propTypes:
    postal_code:  PropTypes.string.isRequired
    birth_year:   PropTypes.string.isRequired
    available:    PropTypes.bool

  @defaultProps:
    available:    false

  render: ->
    {postal_code, birth_year, provider, available} = @props
    <div
      className={cx 'Provider', {available}}
    >
      <h2>{provider.name}</h2>
      {@description()}
      <div className="criteria">
        {@min_age()}
        {@prio_area()}
      </div>
      {@links()}
    </div>

  min_age: ->
    return null unless min_age = @props.provider.min_age
    age_met = @props.provider.filter_age birth_year: parseFloat @props.birth_year
    <p className="min-age">
      {if age_met then "✅ " else "🚫 "}
      Minimum age: <strong>{min_age}</strong>
    </p>

  prio_area: ->
    return null unless @props.provider.filter_prio_postal_code?
    prio_area = @props.provider.filter_prio_postal_code postal_code: @props.postal_code
    <p className="prio-area">
      {if prio_area then "✅ " else "🚫 "}
      Priority area: <strong>{@props.postal_code}</strong>
    </p>

  description: ->
    return null unless __html = @props.provider.description
    <div
      className="description"
      dangerouslySetInnerHTML={{__html}}
    />

  links: ->
    { booking_url, info_url } = @props.provider
    return null unless booking_url or info_url
    <div className="links">
      {<a className="btn booking" href={booking_url}>Make an appointment</a> if booking_url}
      {<a className="btn info" href={info_url}>Learn more</a> if info_url}
    </div>
