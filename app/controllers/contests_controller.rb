class ContestsController < ApplicationController
  before_action :set_contest, only: [:show, :edit]
  before_action :is_login?, only: [:vote, :edit, :new, :create]
  
  def index
    @contests = Contest.all
  end

  def new
    @contest = Contest.new
  end

  def show
    @products = @contest.products
    if current_user.nil?
      @user = nil
      @vote = 0
    else
      @user = User.find(current_user.id)
      @vote = 3 - @user.votes.count
    end
    @chart = @products.map{|pro|
      ["#{pro.title} #{pro.votes.count} 票", pro.votes.count]
    }.sort{|a,b| b[1] <=> a[1]}
    p @chart
  end

  def vote
  end

  def create
    @contest = Contest.new(contest_params)
    @contest[:start_time] = params[:start_time].to_time
    @contest[:end_time] = params[:end_time].to_time
    respond_to do |format|
      if @contest.save
        #これ使ってるのかな
        format.html { redirect_to @contest, notice: '大変よくできました！' }
        format.json { render :show, status: :created, location: @contest }
      else
        format.html { render :new }
        format.json { render json: @contest.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  private
    def set_contest
      @contest = Contest.find(params[:id])
    end

    def contest_params
      params.require(:contest).permit(:admin_id, :title, :detail)
    end
    
    def is_login?
      if session[:uid] == nil
        redirect_to user_google_oauth2_omniauth_authorize_path 
      end
    end
end
