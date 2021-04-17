import React      from "react"
import PropTypes  from "prop-types"

import './styles'

PARTIAL_PAT = /^([ABCEGHJKLMNPRSTVXY]([0-9]([A-Z])?)?)?$/i
COMPLETE_PAT = /^[ABCEGHJKLMNPRSTVXY][0-9][A-Z]$/i

forcePostalCodeFormat = (evt)->
  if /^[A-Z0-9]$/i.test evt.key
    unless PARTIAL_PAT.test evt.target.value + evt.key
      evt.preventDefault()
      return false


export default \
class PostalCodeInput extends React.Component
  @propTypes:
    onChange:     PropTypes.func.isRequired
    value:        PropTypes.string
    placeholder:  PropTypes.string

  @defaultProps:
    value:        ''
    placeholder:  'A1B'

  onChange: (evt)=>
    postal_code = evt?.target?.value?.toUpperCase?()
    @props.onChange postal_code if COMPLETE_PAT.test postal_code

  render: ->
    <input
      className="PostalCodeInput"
      type="text"
      onKeyPress={forcePostalCodeFormat}
      pattern="\w\d\w"
      onKeyUp={@onChange}
      defaultValue={@props.value}
      placeholder={@props.placeholder}
    />
