class Admin::FtpsController < Admin::BaseController
  def index
    @ftp = Ftp.get_ftp_config
  end

  def create
    Ftp.genate_ftp_config( params[:user],
                           params[:passwd],
                           params[:url],
                           params[:port],
                           params[:path]
                        )
    return redirect_to admin_ftps_path
  end
end
