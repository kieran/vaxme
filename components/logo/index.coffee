import React  from "react"
import cx     from "classnames"

import './styles'

export default ({pulse})->
  <div className={cx "Logo", {pulse}}>
    <span>💉</span>
    <span>💪</span>
    <span>😷</span>
  </div>
