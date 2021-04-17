import React      from "react"
import PropTypes  from "prop-types"

import './styles'

PARTIAL_PAT = /^((19|20)([0-9]([0-9])?)?)?$/i
COMPLETE_PAT = /^(19|20)\d{2}$/i

probablyMobile = matchMedia?('(orientation: portrait) and (max-width: 600px)')?.matches or false

export default \
class YearInput extends React.Component
  @propTypes:
    onChange:     PropTypes.func.isRequired
    value:        PropTypes.number
    placeholder:  PropTypes.string

  @defaultProps:
    value:        ''
    placeholder:  '1969'

  onChange: (evt)=>
    val = evt?.target?.value

    if COMPLETE_PAT.test val
      @props.onChange val
      # hide keyboard on phones:
      evt?.target?.blur?() if probablyMobile
    else
      @props.onChange ''

  render: ->
    <input
      className="YearInput"
      type="number"
      min="1900"
      max="2021"
      pattern="[0-9]*"
      inputMode="numeric"
      onKeyUp={@onChange}
      defaultValue={@props.value}
      placeholder={@props.placeholder}
    />
