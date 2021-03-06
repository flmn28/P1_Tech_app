class EvaluationsController < ApplicationController
  before_action :set_notice

  def new
    @post = Post.find(params[:post_id])
    team_members = @post.team_members.where(accepted: true).reject{|m| m.user_id == current_user.id}
    @members = team_members.map{|m| User.find(m.user_id)}
    @members_hash = Hash[@members.map{|m| [m.id, m.username]}].to_json
  end

  def create
    @evaluation = Evaluation.new(evaluation_params)
    if @evaluation.save
      redirect_to root_path
    else
      flash[:notice] = "未選択項目があります"
      redirect_to new_evaluation_path(params[:post_id])
    end
  end

  private

    def evaluation_params
      params.permit(:post_id, :first_evaluated_user, :second_evaluated_user, :third_evaluated_user, :fourth_evaluated_user, :fifth_evaluated_user).merge(user_id: current_user.id)
    end


  def set_notice
    if user_signed_in?
      @notifications = Notification.where(from_user_id: current_user.id, is_read:false)
    end
  end
end
