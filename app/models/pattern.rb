# == Schema Information
#
# Table name: patterns
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  partial_path  :string(255)
#  sub_system_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_patterns_on_sub_system_id  (sub_system_id)
#

class Pattern < ActiveRecord::Base
  # pattern节点配置目录
  CONFIGFILEDIR = "#{Rails.root}/data/patterns/"

  belongs_to :sub_system
  has_many :devices, dependent: :destroy
  has_many :points, through: :devices

  # 不同型号对应节点，分组返回数据
  # 返回值：{ group: [ point ] }
  def point_group
    # 是因为在数据库找不到类似于'旁路输入'、'电池电压'、'旁路输出'等的字段
    # {
    #   '旁路输入' => ['A组', 'B组', 'C组', 'D组', 'E组'],
    #   '电池电压' => ['正电压', '负电压', '总电压'],
    #   '旁路输出' => ['A组', 'B组', 'C组', 'D组', 'E组']
    # }

    point_group = {}
    others = [] # 未分组的节点
    all_points = points.group(:name).pluck(:name)
    all_points.each do |point_name|
      if point_name.include?('-')
        group = point_name.split('-', 2).try(:first)
        if group.present?
          pn = point_name.split('-', 2).try(:last)
          point_group[group].blank? ? point_group[group] = [pn] : point_group[group].push(pn)
        end
      else
        others.push(point_name)
      end
    end
    
    point_group["其他"] = others if others.present?

    point_group

  end

  def get_value_by_point_name devise, point_name
    point = self.points.find_by(name: point_name)
    return nil unless point.present?
    ps = PointState.where(pid: point.point_index.to_i).try(:last)
    value = ps.try(:value)
    value
  end

  # exclude节点设置
  # 参数：groups ; { group : { [point] }}
  def setting_point(groups, exclude_point_info)
    # 配置文件创建
    config_file_create

    # 载入配置
    exclude_points = YAML::load_file(config_file_path) || {}

    # 配置
    groups.each do |group|
      exclude_points[group] = exclude_point_info[group]
    end

    # 将配置写入文件
    File.open(config_file_path, 'w') do |f| 
      f.write exclude_points.to_yaml 
      f.close
    end
  end

  # 根据分组配置获取当前组的显示配置
  # 返回值：{ group : { [point] }}
  def getting_exclude_points
    return {} unless File.exist?(config_file_path) 
    exclude_points = YAML::load_file(config_file_path) || {}
    exclude_points
  end

  # 参数：页面传入的hash { group : { point: 0, point: 1 }}
  # 返回值：exclude的point节点, { group : { [point] }}
  def self.exclude_points_by_params(params)
    exclude_points = {}
    params.each do |group , point|
      ep = point.select{ |p, v| v == '0' }
      exclude_points[group] = ep.keys if ep.present?
    end
    exclude_points
  end

  # 配置文件名
  def config_file_name
    "pattern#{id}.yml"
  end

  # 配置文件完整路径
  def config_file_path
    File.join(CONFIGFILEDIR, config_file_name)
  end

  # 配置文件创建
  def config_file_create
    FileUtils.mkdir_p(CONFIGFILEDIR) unless File.exist?(CONFIGFILEDIR)
    unless File.exist?(config_file_path) 
      file = File.new(config_file_path, 'w') 
      file.close
    end
  end
  
end
