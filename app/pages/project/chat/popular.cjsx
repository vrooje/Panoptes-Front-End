React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
{Link} = require 'react-router'

module.exports = React.createClass
  displayName: 'ProjectChatPopular'

  getDefaultProps: ->
    howMany: 25

  render: ->
    defaultLinkParams =
      owner: @props.owner.display_name
      name: @props.project.display_name

    <div className="content-container">
      Most discussed subjects<br />
      <FirebaseList items={stingyFirebase.child("projects/#{@props.project.id}/subjects").orderByChild('count').limitToLast @props.howMany}>{(subjectID, {count}) =>
        linkParams = Object.create defaultLinkParams
        linkParams.subjectID = subjectID
        <div key={subjectID}>
          <Link to="subject-details" params={linkParams}>{subjectID} ({count})</Link>
        </div>
      }</FirebaseList>
    </div>
