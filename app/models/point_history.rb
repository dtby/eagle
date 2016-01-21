# == Schema Information
#
# Table name: point_histories
#
#  id          :integer          not null, primary key
#  point_name  :string(255)
#  point_value :float(24)
#  point_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_point_histories_on_point_id  (point_id)
#

class PointHistory < ActiveRecord::Base
  belongs_to :point
  belongs_to :device
  default_scope { order('id DESC') }

  # PointHistory.generate_point_history
  def self.generate_point_history
    config = YAML.load_file('config/history.yml')
    interval = config["interval"]
    month = DateTime.now.strftime("%Y%m")

    return if PointHistory.proxy(month: month).first.present? && interval*60 > Time.now - PointHistory.proxy(month: month).first.try(:created_at)
    
    Point.all.each do |point|
      logger.info "point is #{point.name}, device is #{point.try(:device).try(:name)}"
      PointHistory.proxy(month: month).create(point_name: point.name, point_value: point.value, point: point, device_id: point.try(:device).try(:id))
    end
    nil
  end

  # 按月份分表:  201511
  def self.proxy(params={})
    month = params[:month] || params['month']
    if month.present?
      sign = "point_histories_#{month}"
    else
      sign = "point_histories"
    end
    create_table sign unless table_exists? sign
    self.table_name = sign 
    return self
  end

  def self.create_table(my_table_name)
    ActiveRecord::Migration.class_eval do
      create_table my_table_name.to_sym do |t|
        t.string :point_name
        t.float :point_value

        t.timestamps null: false
      end
      add_reference my_table_name.to_sym, :point, index: true
      add_reference my_table_name.to_sym, :device, index: true
    end
  end

  def self.table_exists? (sign=nil)
    ActiveRecord::Base.connection.tables.include? sign
  end

  def self.find_by_point_id point_id
    point_histories = []
    ActiveRecord::Base.connection.tables.each do |table|
      if /point_histories_\d{6}/.match table
        PointHistory.table_name = table
        puts "table is #{table}"
        PointHistory.where(point_id: point_id).each do |point_history|
          point_histories << point_history
        end
      end
    end
    point_histories
  end

  def self.find_by_device_id device_id
    point_histories = []
    ActiveRecord::Base.connection.tables.each do |table|
      if /point_histories_\d{6}/.match table
        PointHistory.table_name = table
        puts "table is #{table}"
        PointHistory.where(device_id: device_id).each do |point_history|
          point_histories << point_history
        end
      end
    end
    point_histories
  end
  
  def self.keyword(start_time, end_time, point_id)
    point_histories = self.find_by_point_id(point_id).reverse
    return point_histories[0..9] if start_time.blank? && end_time.blank?
    devices = []
    self.find_by_point_id(point_id).each do |p|
      created_time = p.created_at.to_datetime
      if start_time.to_datetime <= created_time && created_time - 1.day<= end_time.to_datetime
        devices << p
      end
    end
    devices.reverse[0..9]
  end
end
