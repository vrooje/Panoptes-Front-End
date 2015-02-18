React = require 'react'
PromiseRenderer = require '../../components/promise-renderer'
apiClient = require '../../api/client'
SubjectViewer = require '../../components/subject-viewer'
FirebaseComments = require '../../components/firebase-comments'

module.exports = React.createClass
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
