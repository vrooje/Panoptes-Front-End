React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
{Link} = require 'react-router'
PromiseRenderer = require '../../../components/promise-renderer'
apiClient = require '../../../api/client'
getSubjectLocation = require '../../../lib/get-subject-location'
moment = require 'moment'

module.exports = React.createClass
  displayName: 'ProjectChatPopular'

  getDefaultProps: ->
    howMany: 25

  render: ->
    defaultLinkParams =
      owner: @props.owner.display_name
      name: @props.project.display_name

    <div className="content-container">
      <p><strong>Most discussed subjects</strong></p>
      <FirebaseList items={stingyFirebase.child("projects/#{@props.project.id}/subjects").orderByChild('count').limitToLast @props.howMany}>{(subjectID, {count}) =>
        <PromiseRenderer promise={apiClient.type('subjects').get subjectID}>{(subject) =>
          linkParams = Object.create defaultLinkParams
          linkParams.subjectID = subject.id
          <Link to="subject-details" params={linkParams} key={subject.id} className="chat-link-to-subject">
            <img src={getSubjectLocation(subject).src} className="thumbnail" />
            <span className="count">{count}</span>
          </Link>
        }</PromiseRenderer>
      }</FirebaseList>

      <p><strong>Most popular threads</strong></p>
      <FirebaseList items={stingyFirebase.child("projects/#{@props.project.id}/threads").orderByChild('count').limitToLast @props.howMany}>{(key, thread) =>
        linkParams = Object.create defaultLinkParams
        linkParams.threadID = key
        <p key={key}>
          <Link to="project-chat-thread" params={linkParams} className="secret-button">
            <span className="minor-button">{thread.name}</span>{' '}
            Started by <PromiseRenderer tag="span" promise={apiClient.type('users').get thread.user} then="display_name"/>{' '}
            <time title={moment(thread.timestamp).format 'llll'}>{moment(thread.timestamp).fromNow()}</time>
          </Link>
        </p>
      }</FirebaseList>
    </div>
