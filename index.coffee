GEO_TIMEOUT = 5000

import React        from "react"
import { render }   from "react-dom"
import axios        from 'axios'
import throttle     from 'underscore-es/throttle'

import './styles'

# provide GTM fallback
window.gtag ?= -> window.dataLayer?.push arguments

import providers from '/data/providers'

# routes
import Application  from '/routes/application'

do ->
  if dsn = process.env.SENTRY_DSN_FRONTEND
    Sentry = await import('@sentry/browser')
    Sentry.init { dsn, environment: process.env.NODE_ENV }

  getLocation = ->
    position = await new Promise (resolve, reject)->
      navigator.geolocation.getCurrentPosition resolve, reject, timeout: GEO_TIMEOUT
    {latitude, longitude} = position.coords
    {latitude, longitude}

  getPostalCode = (lat, lng)->
    { data } = await axios.get "#{process.env.API_URL}/#{lat.toFixed 3},#{lng.toFixed 3}"
    data

  fixVh = ->
    document.documentElement.style.setProperty '--vh', "#{window.innerHeight * 0.01}px"

  lastCode = ->
    try
      localStorage.getItem 'postal_code'

  lastYear = ->
    try
      localStorage.getItem 'birth_year'

  remember = (obj={})->
    for key, val of obj
      try
        localStorage.setItem key, val
        localStorage.removeItem key unless val


  class App extends React.Component
    constructor: ->
      super arguments...
      @state =
        locating: false
        geoError: null
        postal_code: lastCode() or null
        birth_year: lastYear() or null

    componentDidMount: ->
      @autoLocate() unless @state.postal_code
      fixVh()
      window.addEventListener 'resize', throttle fixVh, 200

    autoLocate: =>
      try
        @setState locating: true
        {latitude, longitude} = await getLocation()
        if latitude and longitude and postal_code = await getPostalCode latitude, longitude
          gtag 'event', 'postal_code-select-auto', event_category: 'engagement', event_label: postal_code
          @setPostalCode postal_code
      catch err
        # retry a timeout once
        setTimeout @autoLocate.bind(@), 0 if err.TIMEOUT unless @state.geoError
        @setState geoError: err.message
      finally
        @setState locating: false

    setPostalCode: (postal_code)=>
      remember { postal_code }
      @setState { postal_code }

    setBirthYear: (birth_year)=>
      birth_year = parseFloat birth_year
      remember { birth_year }
      @setState { birth_year }

    render: ->
      <Application
        providers={providers}
        postal_code={@state.postal_code}
        birth_year={@state.birth_year}
        setPostalCode={@setPostalCode}
        setBirthYear={@setBirthYear}
        autoLocate={@autoLocate}
        locating={@state.locating}
      />

  render <App />, document.getElementById "Application"
