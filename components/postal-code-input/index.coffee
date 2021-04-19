import React      from "react"
import PropTypes  from "prop-types"

import './styles'

PARTIAL_PAT = /^([ABCEGHJKLMNPRSTVXY]([0-9]([A-Z])?)?)?$/i
COMPLETE_PAT = /^[ABCEGHJKLMNPRSTVXY][0-9][A-Z]$/i

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
    if COMPLETE_PAT.test val = evt?.target?.value
      @props.onChange val.toUpperCase()
    else
      @props.onChange ''

  render: ->
    <input
      className="PostalCodeInput"
      type="text"
      pattern="\w\d\w"
      onKeyUp={@onChange}
      defaultValue={@props.value}
      placeholder={@props.placeholder}
    />
