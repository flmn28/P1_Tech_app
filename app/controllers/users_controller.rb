class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_notice
  before_action :authenticate_user!



  def index
    @user = current_user

  end

  def show
    set_evaluations
    @planning_posts = @user.team_members.where(accepted: true).map {|m| Post.find_by(id: m.post_id, status: 0)}.compact
    @developing_posts = @user.team_members.where(accepted: true).map {|m| Post.find_by(id: m.post_id, status: 1)}.compact
    @released_posts = @user.team_members.where(accepted: true).map {|m| Post.find_by(id: m.post_id, status: 2)}.compact
  end

  def edit
    return redirect_to edit_user_path(current_user) unless current_user == User.find(params[:id])
    @user = User.find(params[:id])
  end

  def update
    return redirect_to user_path(current_user) unless current_user == User.find(params[:id])
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def set_user
      return redirect_to root_path flash[:notice] = "お探しのユーザーは見つかりませんでした。" unless User.find_by(id: params[:id])
      @user = User.find(params[:id])
    end

    def set_evaluations
      evaluation_columns = [:first_evaluated_user, :second_evaluated_user, :third_evaluated_user, :fourth_evaluated_user, :fifth_evaluated_user]
      @evaluations = Hash[*evaluation_columns.map { |column| [column.to_s, Evaluation.where(column => @user.id).count] }.flatten]
    end

    def user_params
      params.require(:user).permit(:username, :email, :role, :college, :major, :graduation_year, :introduction, :url_1, :url_2, :url_3)
    end

    def set_notice
      if user_signed_in?
        @notifications = Notification.where(from_user_id: current_user.id, is_read:false)
      end
    end
end
