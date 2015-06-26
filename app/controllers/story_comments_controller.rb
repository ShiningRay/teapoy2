class StoryCommentsController < ApplicationController
  before_action :set_story_comment, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @story_comments = StoryComment.all
    respond_with(@story_comments)
  end

  def show
    respond_with(@story_comment)
  end

  def new
    @story_comment = StoryComment.new
    respond_with(@story_comment)
  end

  def edit
  end

  def create
    @story_comment = StoryComment.new(story_comment_params)
    @story_comment.save
    respond_with(@story_comment)
  end

  def update
    @story_comment.update(story_comment_params)
    respond_with(@story_comment)
  end

  def destroy
    @story_comment.destroy
    respond_with(@story_comment)
  end

  private
    def set_story_comment
      @story_comment = StoryComment.find(params[:id])
    end

    def story_comment_params
      params.require(:story_comment).permit(:story_id, :author_id, :content)
    end
end
