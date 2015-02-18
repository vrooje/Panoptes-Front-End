React = require 'react'
TitleMixin = require '../../lib/title-mixin'
PromiseRenderer = require '../../components/promise-renderer'
apiClient = require '../../api/client'
SubjectViewer = require '../../components/subject-viewer'
FirebaseComments = require '../../components/firebase-comments'

module.exports = React.createClass
  mixins: [TitleMixin]

  title: ->
    "Subject details"

  render: ->
    <PromiseRenderer promise={apiClient.type('subjects').get @props.params.id}>{(subject) =>
      <div className="subject-details-page columns-container content-container">
        <div className="classifier">
          <SubjectViewer subject={subject} />
        </div>
        <hr />
        <FirebaseComments type="subject" id={subject.id} />
      </div>
    }</PromiseRenderer>
