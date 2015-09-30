class Admin::AdminsController < Admin::BaseController
	before_action :set_admin, only: [:edit, :update, :destroy]
	before_action :set_admins, only: [:index, :create, :update, :destroy]
	respond_to :html, :js
	def index
	end

	def new
		@admin = Admin.new
		respond_with @admin
	end

	def create
		@admin = Admin.new(admin_params)
		if @admin.save
			flash[:success] = "创建管理员成功"
			respond_to do |format|
				format.js { render js: "location.href = '#{admin_admins_path}'" }
			end
		else
			render :new
		end
	end

	def edit
		respond_with @admin
	end

	def update
		if @admin.update_admin(admin_params)
			flash[:success] = "更新管理员成功"
			respond_to do |format|
				format.js { render js: "location.href = '#{admin_admins_path}'" }
			end
		else
			render :edit
		end
	end

	def destroy
		@admin.destroy
		flash[:success] = "删除管理员成功"
		respond_to do |format|
			format.js { render js: "location.href = '#{admin_admins_path}'" }
		end
	end

	 private
	 def admin_params
	 	params.require(:admin).permit(:email, :password, :name, :phone, :password_confirmation)
	 end

	 def set_admin
	 	@admin = Admin.find(params[:id])
	 end

	 def set_admins
		@admins = Admin.all
	 end
end