class Admin::AttachmentsController < Admin::BaseController
  before_action :set_attachment, only: [:edit, :show, :update, :delete]
  respond_to :html, :js
  load_and_authorize_resource

  def index
    @attachments = Attachment.where(room: current_admin.rooms).enabled.paginate(page: params[:page], per_page: 15)
    respond_with @attachments
  end

  def new
    @attachment = Attachment.new
    if current_admin.grade == 'room'
      @room = current_admin.rooms
    else
      @room = Room.all
    end
    respond_with @attachment
  end

  def create
    @attachment = Attachment.new(attachment_params)
    if @attachment.save
      flash[:notice] = "创建成功"
    else
      flash[:error] = "创建失败"
    end
    return redirect_to admin_attachments_path
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
    return redirect_to admin_attachments_path
    # return render js: "window.location.href = '#{admin_attachments_path}';"
  end

  def delete
    @attachment.update(deleted_at: Time.now)
    flash[:notice] = '删除成功'
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
