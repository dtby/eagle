class SubSystemController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :set_room
  respond_to :json

  # [,   "配电柜", "机柜动力", "发电机",  "电量仪系统", "风冷系统", "空调系统", "消防系统", "漏水系统", "烟感系统", "氢气检测系统", "电池系统", nil]
  # 配电, "配电系统"

  def search
    system = @room.systems.find_by(id: params[:system_id])
    if system.present? && system.sub_systems.present?
      sub_system = system.sub_systems.find_by(name: params[:sub_sys_name])
      patterns = sub_system.try(:patterns)
      @devices = []
      if patterns.present?
        patterns.collect { |pattern| @devices.concat pattern.try(:devices)}
      end
    end
  end
  # def distrib
  #   system = @room.system.find_by(sys_name: "动力")
  #   sub_system = system.find_by(name: "配电系统")
  #   @devices = sub_system.try(:devices)
  # end

  # # UPS, "UPS系统"
  # def ups
  #   system = @room.system.find_by(sys_name: "动力")
  #   sub_system = system.find_by(name: "UPS系统")
  #   @devices = sub_system.try(:devices)
  # end

  # # 列头柜
  # def column_head_cabinet
  # end

  # # ATS
  # def ats
  # end

  # # 蓄电池, "电池"
  # def battery
  #   system = @room.system.find_by(sys_name: "动力")
  #   sub_system = system.find_by(name: "电池")
  #   @devices = sub_system.try(:devices)
  # end

  # # 柴油机
  # def diesel_engine
  # end

  # # 温湿度, "温湿度系统"
  # def temperature_humidity
  #   system = @room.system.find_by(sys_name: "动力")
  #   sub_system = system.find_by(name: "温湿度系统")
  #   @devices = sub_system.try(:devices)
  # end

  # # 漏水, "漏水检测"
  # def water_leakage
  #   system = @room.system.find_by(sys_name: "漏水")
  #   sub_system = system.find_by(name: "漏水检测")
  #   @devices = sub_system.try(:devices)
  # end

  # # 精密空调, "精密空调"
  # def air_d
  #   system = @room.system.find_by(sys_name: "精密空调")
  #   sub_system = system.find_by(name: "精密空调")
  #   @devices = sub_system.try(:devices)
  # end
    
  # # 机柜温湿度, "机柜环境"
  # def cabinet_temp_humidity
  #   system = @room.system.find_by(sys_name: "机柜温湿度")
  #   sub_system = system.find_by(name: "机柜环境")
  #   @devices = sub_system.try(:devices)
  # end

  # def wind
  # end

  # def crac    
  # end

  private
  
  def set_room
    @room = Room.where(id: params[:id]).first
  end

end
