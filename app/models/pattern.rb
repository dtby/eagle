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
  CONFIGFILEPATH = "#{Rails.root}/data/patterns/"

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

  # 配置文件名
  def config_file_name
    "pattern#{id}.yml"
  end

  # 配置文件创建
  def config_file_create
    file_path = File.join(CONFIGFILEPATH, config_file_name)
    FileUtils.mkdir_p(CONFIGFILEPATH) unless File.exist?(CONFIGFILEPATH)
    unless File.exist?(file_path) 
      file = File.new(file_path, 'w') 
      file.close
    end
  end

  # exclude节点设置
  # 参数：{ group : { [point] }}
  def setting_point(point_info)
    file_path = File.join(CONFIGFILEPATH, config_file_name)
    pattern_config = YAML::load_file(file_path) || {}

    # 新的配置
    point_info.each do |key, value|
      pattern_config[key] = value
    end

    # 将新的配置写入文件
    File.open(file_path, 'w') do |f| 
      f.write pattern_config.to_yaml 
      f.close
    end
  end
end
