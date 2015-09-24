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

  # 不同型号对应节点，分组返回数据
  # 返回值：{ group: [ point ] }
  def point_group
    {
      '旁路输入' => ['A组', 'B组', 'C组', 'D组', 'E组'],
      '旁路输出' => ['A组', 'B组', 'C组', 'D组', 'E组'],
      '电池电压' => ['正电压', '负电压', '总电压']
    }
  end

  # 根据分组配置获取当前组的显示配置
  # 返回值：[ exclude_point ]
  def getting_point_by_group(group)
    return [] unless File.exist?(config_file_path) 
    exclude_points = YAML::load_file(config_file_path) || {}
    exclude_points[group] || []
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

  # exclude节点设置
  # 参数：{ group : { [point] }}
  def setting_point(exclude_point_info)
    # 配置文件创建
    config_file_create

    # 载入配置
    exclude_points = YAML::load_file(config_file_path) || {}

    # 配置
    exclude_point_info.each { |key, value| exclude_points[key] = value }

    # 将配置写入文件
    File.open(config_file_path, 'w') do |f| 
      f.write exclude_points.to_yaml 
      f.close
    end
  end
end
