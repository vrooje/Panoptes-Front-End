React = require 'react'
TitleMixin = require '../../lib/title-mixin'
PromiseRenderer = require '../../components/promise-renderer'
apiClient = require '../../api/client'
SubjectViewer = require '../../components/subject-viewer'
FirebaseList = require '../../components/firebase-list'
stingyFirebase = require '../../lib/stingy-firebase'
{Link} = require 'react-router'
Comment = require './chat/comment'
ChangeListener = require '../../components/change-listener'
auth = require '../../api/auth'
PromiseRenderer = require '../../components/promise-renderer'

module.exports = React.createClass
  mixins: [TitleMixin, stingyFirebase.Mixin]

  title: ->
    "Subject details"

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="subject-details-page columns-container content-container">
      <PromiseRenderer promise={apiClient.type('subjects').get @props.params.subjectID}>{(subject) =>
        <div className="column">
          <div className="classifier">
            <SubjectViewer subject={subject} />
          </div>

          <p>
            Hashtags:{' '}
            <FirebaseList ref="hashtagsList" tag="span" items={stingyFirebase.child "projects/#{@props.project.id}/subjects/#{@props.params.subjectID}/hashtags"} empty="None">{(hashtag, count) =>
              <span><Link to="project-chat-search" params={@props.params} query={q: encodeURIComponent "##{hashtag}"} className="pill-button">#{hashtag}</Link> </span>
            }</FirebaseList>
          </p>
          <p>Add your own by leaving a comment.</p>
        </div>
      }</PromiseRenderer>

      <div className="column">
        <FirebaseList ref="commentsList" items={commentsRef.orderByChild('subject').equalTo @props.params.subjectID} empty="No comments yet">{(key, comment) =>
          unless comment.flagged
            <Comment key={key} comment={comment} reference={commentsRef.child key} />
        }</FirebaseList>

        <hr />

        <ChangeListener target={auth}>{=>
          <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
            if user?
              <div>
                <p><strong>Leave a comment</strong></p>
                <form onSubmit={@handleSubmit}>
                  <textarea name="comment-content" className="standard-input full" /><br />
                  <button type="submit" className="standard-button">Save comment</button>
                </form>
              </div>
            else
              <p><strong>Sign in leave a comment</strong></p>
          }</PromiseRenderer>
        }</ChangeListener>
      </div>
    </div>

  handleSubmit: (e) ->
    e.preventDefault()

    contentInput = @getDOMNode().querySelector '[name="comment-content"]'

    stingyFirebase.child("projects/#{@props.project.id}/comments").push
      subject: @props.params.subjectID
      content: contentInput.value
      user: stingyFirebase.getAuth().uid
      timestamp: Firebase.ServerValue.TIMESTAMP

    stingyFirebase.child("projects/#{@props.project.id}/subjects/#{@props.params.subjectID}/last-update").set Firebase.ServerValue.TIMESTAMP
    stingyFirebase.child("projects/#{@props.project.id}/subjects/#{@props.params.subjectID}/count").transaction (count) ->
      count ?= 0
      count + 1

    for hashtag in contentInput.value.match /#\S+\w/g
      stingyFirebase.child("projects/#{@props.project.id}/subjects/#{@props.params.subjectID}/hashtags/#{hashtag.slice 1}").transaction (count) ->
        count ?= 0
        count + 1

    contentInput.value = ''
    @refs.commentsList.displayAll()
