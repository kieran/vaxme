import React      from "react"
import PropTypes  from "prop-types"

import './styles'

PARTIAL_PAT = /^([ABCEGHJKLMNPRSTVXY]([0-9]([A-Z])?)?)?$/i
COMPLETE_PAT = /^[ABCEGHJKLMNPRSTVXY][0-9][A-Z]$/i

# prevent similar-but-not-valid
# postal codes (the forbidden six)
sanitizeInput = (evt)->
  if /[DFIOQU]/i.test evt.key
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
    val = evt?.target?.value

    if COMPLETE_PAT.test val
      @props.onChange val.toUpperCase()
    else
      @props.onChange ''

  render: ->
    <input
      className="PostalCodeInput"
      type="text"
      onKeyPress={sanitizeInput}
      pattern="\w\d\w"
      onKeyUp={@onChange}
      defaultValue={@props.value}
      placeholder={@props.placeholder}
    />
