class StoriesController < ApplicationController
  before_action :set_guestbook
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @stories = Story.all
    respond_with(@stories)
  end

  def show
    respond_with(@story)
  end

  def new
    @story = Story.new
    respond_with(@story)
  end

  def edit
  end

  def create
    @story = Story.new(story_params)
    @story.save
    respond_with(@story)
  end

  def update
    @story.update(story_params)
    respond_with(@story)
  end

  def destroy
    @story.destroy
    respond_with(@story)
  end

  private
    def set_story
      @story = @guestbook.stories.find(params[:id])
    end

    def set_guestbook
      @guestbook = Guestbook.find params[:guestbook_id]
    end

    def story_params
      params.require(:story).permit(:guestbook_id, :author_id, :body)
    end
end
