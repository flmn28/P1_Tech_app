class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_templates, only: [:new, :create, :edit, :update]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new(num_of_planner: 0, num_of_engineer: 0, num_of_designer: 0, num_of_graphicer: 0)
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.status = 0
    if params[:commit] == '下書きに保存'
      @post.private_flag = true
    else
      @post.private_flag = false
    end

    # respond_to do |format|
      if @post.valid? && num_of_members_valid?
        @post.save
        if @post.private_flag
          @save_type = 'private'
        else
          @save_type = 'public'
        end
        # format.html { redirect_to @post, notice: 'Post was successfully created.' }
        # format.json { render :show, status: :created, location: @post }
      else
        @post.errors.messages[:members] = ['must be added in at least one job type'] if !num_of_members_valid?
        # format.html { render :new }
        # format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    # end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_templates
      @templates = Template.all
    end

    def num_of_members_valid?
      if @post.num_of_planner == 0 && @post.num_of_engineer == 0 && @post.num_of_designer == 0 && @post.num_of_graphicer == 0
        return false
      end
      return true
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :outline, :detail, :image, :template_id, :user_id, :private_flag, :status, :num_of_planner, :num_of_engineer, :num_of_designer, :num_of_graphicer)
    end
end
