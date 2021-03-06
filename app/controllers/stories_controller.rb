class StoriesController < ApplicationController
  before_action :set_guestbook
  before_action :set_story, only: [:show, :edit, :update, :destroy]
  before_action :login_required, only: [:edit, :update, :destroy, :like, :unlike]
  respond_to :html

  def index
    @stories = @guestbook.stories.latest.page(params[:page]).decorate
    respond_with(@stories)
  end

  def show
    @story = @story.decorate
    respond_with(@story)
  end

  def new
    @story = @guestbook.stories.new
    respond_with(@story)
  end

  def edit
    respond_with(story)
  end

  def create
    @story = @guestbook.stories.new(story_params)
    if logged_in?
      @story.author = current_user
    elsif User.where(email: @story.email).exists?
      flash[:error] = '您提供的邮箱已被注册，请登录'
      return redirect_to(new_session_path)
    end
    @story.save
    respond_with(@story, location: [guestbook, :stories])
  end

  def update
    @story.update(story_params)
    respond_with(@story)
  end

  def destroy
    story.destroy if current_user == story.author
    respond_with(story, location: [guestbook, :stories])
  end

  def like
    @like = Like.create user: current_user, story: story
    respond_with @like, location: [guestbook, story]
  end

  def unlike
    Like.where(user: current_user, story: story).delete_all
    respond_with @story, location: [guestbook, story]
  end

  private
    def set_story
      @story = @guestbook.stories.find(params[:id])
    end

    def story
      @story ||= scope.find(params[:id])
    end

    def scope
      guestbook.stories
    end

    def set_guestbook
      @guestbook = Guestbook.find params[:guestbook_id]
    end

    def guestbook
      @guestbook ||= Guestbook.find params[:guestbook_id]
    end

    def story_params
      params.require(:story).permit(:guestbook_id, :content, :picture, :remote_picture_url, :anonymous, :email)
    end
end
