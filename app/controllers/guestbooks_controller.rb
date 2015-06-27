class GuestbooksController < ApplicationController
  before_action :set_guestbook, only: [:show, :edit, :update, :destroy]

  # respond_to :html
  #
  def index
    @guestbooks = Guestbook.all
    respond_with(@guestbooks)
  end
  #
  # def show
  #   respond_with(@guestbook)
  # end
  #
  # def new
  #   @guestbook = Guestbook.new
  #   respond_with(@guestbook)
  # end
  #
  # def edit
  # end
  #
  # def create
  #   @guestbook = Guestbook.new(guestbook_params)
  #   @guestbook.save
  #   respond_with(@guestbook)
  # end
  #
  # def update
  #   @guestbook.update(guestbook_params)
  #   respond_with(@guestbook)
  # end
  #
  # def destroy
  #   @guestbook.destroy
  #   respond_with(@guestbook)
  # end
  #
  private
    def set_guestbook
      @guestbook = Guestbook.find(params[:id])
    end

    def guestbook_params
      params.require(:guestbook).permit(:name, :owner, :description)
    end
end
