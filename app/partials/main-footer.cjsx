counterpart = require 'counterpart'
React = require 'react'
Translate = require 'react-translate-component'
{Link} = require 'react-router'

counterpart.registerTranslations 'en',
  footer:
    privacyPolicy: 'Privacy policy'

Spacer = React.createClass
  displayName: 'FooterSpacer'

  render: ->
    <span style={
      display: 'inline-block'
      textAlign: 'center'
      padding: '0 0.6vw'
    }>{@props.children}</span>

module.exports = React.createClass
  displayName: 'MainFooter'

  render: ->
    <footer className="main-footer">
      <strong>© 2015 <a href="https://www.zooniverse.org/">Zooniverse</a></strong>
      <Spacer />
      <a href="https://www.zooniverse.org/projects">Projects</a>
      <Spacer />
      <a href="https://www.zooniverse.org/lab">Lab</a>
      <Spacer />
      <a href="https://www.zooniverse.org/about">About</a>
      <Spacer />
      <a href="https://www.zooniverse.org/researchers">Researchers</a>
      <Spacer />
      <a href="https://www.zooniverse.org/education">Education</a>
      <Spacer />
      <a href="https://www.zooniverse.org/privacy">Privacy</a>
      <Spacer />
      <a href="https://www.zooniverse.org/contact">Contact</a>

      <br />

      <strong>Our partners:</strong>
      <Spacer />
      <a href="http://www.ox.ac.uk/">University of Oxford</a>
      <Spacer />
      <a href="http://www.adlerplanetarium.org/">Adler Planetarium</a>
      <Spacer />
      <a href="http://www.umn.edu/">University of Minnesota</a>
      <Spacer />
      <a href="https://www.google.org/">Google.org</a>
      <Spacer />
      <a href="http://www.sloan.org/">Alfred P. Sloan Foundation</a>

      <hr />

      <a href="https://www.facebook.com/therealzooniverse" title="Facebook"><i className="fa fa-facebook-square fa-fw fa-2x"></i></a>
      <Spacer />
      <a href="https://twitter.com/the_zooniverse" title="Twitter"><i className="fa fa-twitter fa-fw fa-2x"></i></a>
      <Spacer />
      <a href="https://plus.google.com/109138735542732963088" title="Google+" rel="publisher"><i className="fa fa-google-plus fa-fw fa-2x"></i></a>
      <Spacer />
      <a href="https://github.com/zooniverse" title="GitHub"><i className="fa fa-github fa-fw fa-2x"></i></a>
    </footer>
