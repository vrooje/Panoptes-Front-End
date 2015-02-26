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
        <div>
          <div className="classifier">
            <SubjectViewer subject={subject} />
          </div>

          <FirebaseList items={stingyFirebase.child "projects/#{@props.project.id}/subjects/#{@props.params.subjectID}/hashtags"}>{(hashtag, count) =>
            <span><Link to="project-chat-search" params={@props.params} query={q: encodeURIComponent "##{hashtag}"}>#{hashtag}</Link> </span>
          }</FirebaseList>
        </div>
      }</PromiseRenderer>

      <hr />

      <div>
        <FirebaseList ref="list" items={commentsRef.orderByChild('subject').equalTo @props.params.subjectID}>{(key, comment) =>
          unless comment.flagged
            <Comment key={key} comment={comment} reference={commentsRef.child key} />
        }</FirebaseList>

        <ChangeListener target={auth}>{=>
          <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
            if user?
              <form onSubmit={@handleSubmit.bind this, @props.project?.id ? @props.params.projectID, @props.params.subjectID}>
                <textarea name="comment-content" /><br />
                <button type="submit">Save comment</button>
              </form>
            else
              <p>Sign in leave a comment</p>
          }</PromiseRenderer>
        }</ChangeListener>
      </div>
    </div>

  handleSubmit: (projectID, subjectID, e) ->
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
    @refs.list.displayAll()
