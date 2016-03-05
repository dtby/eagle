class Admin::AttachmentsController < Admin::BaseController
  before_action :set_attachment, only: [:edit, :show, :update, :destroy]
  respond_to :html, :js

  def new
    @attachment = Attachment.new
    respond_with @attachment
  end

  def create
    @attachment = Attachment.new(attachment_params)
    if @attachment.save
      flash[:notice] = "创建成功"
      respond_with @attachments
    else
      flash[:error] = "创建失败"
      render :new
    end
  end

  def index
    @attachments = Attachment.all
  end

  def edit
    respond_with @attachment
  end

  def update
    if @attachment.update(attachment_params)
      flash[:notice] = "更新成功"
    else
      flash[:notice] = "更新失败"
    end
  end

  def destroy
    @attachment.destroy
    redirect_to admin_attachments_path
  end

  def show

  end

  private

  def attachment_params
    params.require(:attachment).permit(:image, :tag, :room_id)
  end

  def set_attachment
    @attachment = Attachment.where(id: params[:id]).first
  end

end
