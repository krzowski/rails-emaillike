class DraftsController < ApplicationController
  before_action :require_login
  before_action :set_drafts, only: [:index, :show]

  def index
  end

  def show
    @draft = @drafts.find(params[:id])
    respond_to do |format|
      format.html { render "show" }
      format.js   { render "draft.js.erb", layout: false } 
    end
  end

  def update
    if params[:send_draft]
      if current_user.emails.new(draft_params).valid?
        destroy_draft
        create_email(draft_params) #method delegated to emails_helper
      else
        flash.now[:danger] = "All fields need to be filled to send the message"
        @draft = Draft.new(draft_params)
        set_drafts
        render 'show'
      end
    else
      @draft = current_user.drafts.find(params[:id])
      if @draft.update_attributes(draft_params)
        flash[:success] = "Draft was updated"
        redirect_to draft_path(@draft)
      else
        flash.now[:danger] = "To and Title fields need to be filled"
        @draft = Draft.new(draft_params)
        set_drafts
        render 'show'
      end
    end
  end

  def destroy
    destroy_draft
    flash[:danger] = "Draft was deleted"
    redirect_to drafts_path
  end

  private
    def draft_params
      params.require(:draft).permit(:title, :username, :message)
    end

    def sort_drafts
      session[:sorting] = params[:sort] ? params[:sort] : session[:sorting] || 'newest'
      @drafts = @drafts.send(session[:sorting])
    end

    def set_drafts
      session[:collection] = 'drafts'
      @drafts = current_user.drafts
      sort_drafts
    end

    def destroy_draft
      current_user.drafts.find(params[:id]).destroy
    end
end
