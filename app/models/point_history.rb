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
  default_scope { order('id DESC') }

  # PointHistory.generate_point_history
  def self.generate_point_history
    config = YAML.load_file('config/history.yml')
    interval = config["interval"]

    return if PointHistory.last.present? && interval*60 > Time.now - PointHistory.last.try(:created_at)
    
    month = DateTime.now.strftime("%Y%m")
    Point.all.each do |point|
      puts "point is #{point.name}"
      PointHistory.proxy(month: month).create(point_name: point.name, point_value: point.value, point: point)
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
    point_histories.sort_by{ |a| a[:created_at] }.reverse!
  end

end
