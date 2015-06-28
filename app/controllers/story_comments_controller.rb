class StoryCommentsController < ApplicationController
  before_action :set_story_comment, only: [:show, :edit, :update, :destroy]

  def index
    @story_comments = scope.all
    respond_with(@story_comments)
  end

  # def new
  #   @story_comment = StoryComment.new
  #   respond_with(@story_comment)
  # end

  def create
    @story_comment = scope.new(story_comment_params)
    @story_comment.author = current_user
    @story_comment.save
    respond_with(@story_comment, location: [guestbook, story, :story_comments])
  end

  # def update
  #   @story_comment.update(story_comment_params)
  #   respond_with(@story_comment)
  # end

  def destroy
    story_comment.destroy if current_user == story_comment.author
    respond_with(story_comment, location: [guestbook, story, :story_comments])
  end

  private
    def set_story_comment
      @story_comment = scope.find(params[:id])
    end

    def story_comment_params
      params.require(:story_comment).permit(:content)
    end

    def story_comment
      @story_comment ||= scope.find params[:id]
    end

    def story
      @story ||= guestbook.stories.find params[:story_id]
    end

    def guestbook
      @guestbook ||= Guestbook.find params[:guestbook_id]
    end

    def scope
      story.comments
    end
end
