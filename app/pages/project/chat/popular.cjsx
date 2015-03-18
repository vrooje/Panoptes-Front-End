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
      <div className="columns-container">
        <div>
          <p><strong>Popular hashtags</strong></p>
          <FirebaseList items={stingyFirebase.child("projects/#{@props.project.id}/hashtags").orderByValue().limitToLast Math.floor @props.howMany / 2}>{(hashtag, count) =>
            <p><Link to="project-chat-search" params={@props.params} query={q: encodeURIComponent "##{hashtag}"} className="minor-button full">#{hashtag} <span className="badge">{count}</span></Link></p>
          }</FirebaseList>
        </div>

        <div className="column">
          <p><strong>Most discussed subjects</strong></p>
          <FirebaseList items={stingyFirebase.child("projects/#{@props.project.id}/subjects").orderByChild('count').limitToLast @props.howMany}>{(subjectID, {count}) =>
            <PromiseRenderer promise={apiClient.type('subjects').get subjectID}>{(subject) =>
              linkParams = Object.create defaultLinkParams
              linkParams.subjectID = subject.id
              <Link to="subject-details" params={linkParams} key={subject.id} className="chat-link-to-subject">
                <img src={getSubjectLocation(subject).src} className="thumbnail" />
                <span className="badge">{count}</span>
              </Link>
            }</PromiseRenderer>
          }</FirebaseList>
        </div>
      </div>

      <hr />

      <div>
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
    </div>
