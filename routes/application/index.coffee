import React        from "react"
import { render }   from "react-dom"
import cx           from "classnames"

import './styles'

# components
import Provider         from '/components/provider'
import PostalCodeInput  from '/components/postal-code-input'
import YearInput        from '/components/year-input'
import Logo             from '/components/logo'

import FacebookShareButton  from 'react-share/es/FacebookShareButton'
import TwitterShareButton   from 'react-share/es/TwitterShareButton'
import RedditShareButton    from 'react-share/es/RedditShareButton'
import EmailShareButton     from 'react-share/es/EmailShareButton'
import Facebook from 'react-icons/lib/fa/facebook'
import Twitter  from 'react-icons/lib/fa/twitter'
import Reddit   from 'react-icons/lib/fa/reddit-alien'
import Envelope from 'react-icons/lib/fa/envelope'

export default \
class Application extends React.Component

  providers: =>
    return [] unless postal_code = @props.postal_code
    (p for p in @props.providers when p.match @props)

  available_providers: ->
    (p for p in @providers() when p.filter @props)

  other_providers: ->
    (p for p in @providers() when not p.filter @props)

  render: ->
    <div className="vaxme">
      {[
        @header()
        @main()     unless @props.locating
        @footer()   unless @props.locating
      ]}
    </div>

  header: ->
    { locating } = @props
    <header className={cx {locating}} key='header'>
      <Logo pulse={locating}/>
    </header>

  main: ->
    <main key='main'>
      <div className="input">
        {@postal_code()}
        {@birth_year()}
      </div>
      {if @props.postal_code and @props.birth_year
        <div className="output">
          {@best_bet()}
          {@other_available()}
          {@not_available()}
        </div>
      }
    </main>

  postal_code: ->
    <div className="postal-code">
      <label>Your postal code</label>
      <PostalCodeInput
        onChange={@props.setPostalCode}
        value={@props.postal_code}
      />
    </div>

  birth_year: ->
    <div className="birth-year">
      <label>Your birth year</label>
      <YearInput
        onChange={@props.setBirthYear}
        value={@props.birth_year}
      />
    </div>

  best_bet: ->
    return null unless p = @available_providers()?[0]
    <>
      <h1>Your best bet</h1>
      <Provider
        key={p.name}
        provider={p}
        postal_code={@props.postal_code}
        birth_year={@props.birth_year}
        available={true}
      />
    </>

  other_available: ->
    rest = @available_providers()?[1..]
    return null unless rest.length
    <>
      <h1>You also qualify for</h1>
      {for p in rest
        <Provider
          key={p.name}
          provider={p}
          postal_code={@props.postal_code}
          birth_year={@props.birth_year}
          available={true}
        />
      }
    </>

  not_available: ->
    others = @other_providers()
    return null unless others.length
    <>
      <h1>You may still qualify</h1>
      <div className="notice">
        <p>You may be a member of a priority group.</p>
        <p>
          Examples include:
          <ul>
            <li>Frontline health care workers</li>
            <li>People with high-risk health conditions</li>
            <li>Residents, staff and essential caregivers in long-term care homes</li>
            <li>First Nations, Métis, or Inuit people</li>
          </ul>
        </p>
        <p>Please consult the links below for more information.</p>
      </div>
      {for p in others
        <Provider
          key={p.name}
          provider={p}
          postal_code={@props.postal_code}
          birth_year={@props.birth_year}
          available={false}
        />
      }
    </>

  footer: ->
    <footer key='footer'>
      <div className="top">
        <Logo />
        {@share()}
      </div>
      <div className="bottom">
        {@links()}
      </div>
    </footer>

  share: ->
    url = window.location.href
    <div className="share" key="share">
      <EmailShareButton
        url={url}
        subject={"VaxMe: Where to find COVID-19 vaccines in Canada"}
      >
        <Envelope/>
      </EmailShareButton>
      <TwitterShareButton url={url}>
        <Twitter/>
      </TwitterShareButton>
      <FacebookShareButton url={url}>
        <Facebook/>
      </FacebookShareButton>
      <RedditShareButton url={url}>
        <Reddit/>
      </RedditShareButton>
    </div>

  links: ->
    { t } = @props
    <div className="links" key="links">
      <a href={'https://vaccinehunters.ca'}>
        Community Support (Vaccine Hunters)
      </a>
      <a href={'https://www150.statcan.gc.ca/n1/en/catalogue/92-179-X'}>
        Maps
      </a>
      <a href="https://github.com/kieran/vaxme">
        Code
      </a>
    </div>
