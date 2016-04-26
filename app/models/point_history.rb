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
  @@lock = Mutex.new
  @@lock_tables = Mutex.new

  belongs_to :point
  belongs_to :device
  default_scope { order('id DESC') }

  # PointHistory.generate_point_history
  def self.generate_point_history
    start_time = DateTime.now.strftime("%Q").to_i
    config = YAML.load_file('config/history.yml')
    interval = config["interval"]
    month = DateTime.now.strftime("%Y%m")

    if PointHistory.proxy(month: month).all.size != 0
      return if PointHistory.proxy(month: month).first.present? && interval*60 > Time.now - PointHistory.proxy(month: month).first.try(:created_at)
    end

    Point.all.each do |point|
      next if point.try(:name).try(:include?, "告警-")

      begin
        PointHistory.proxy(month: month).create(point_name: point.name, point_value: point.value, point: point, device_id: point.try(:device).try(:id))
      rescue Exception => e
        logger.info "point is #{point.name}, device is #{point.try(:device).try(:name)}, failed, Exception is #{e}"
        next
      end
    end
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "PointHistory.generate_point_history time is #{end_time-start_time}"
    nil
  end

  # 按月份分表:  201511
  def self.proxy(params={})
    @@lock.synchronize do
      month = params[:month] || params['month']
      if month.present?
        sign = "point_histories_#{month}"
      else
        sign = "point_histories"
      end
      create_table sign unless table_exists? sign
      self.table_name = sign
    end
    return self
  end

  def self.create_table(my_table_name)
    ActiveRecord::Migration.class_eval do
      create_table my_table_name.to_sym do |t|
        t.string :point_name
        t.string :point_value

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
    @@lock.synchronize do
      ActiveRecord::Base.connection.tables.each do |table|
        if /point_histories_\d{6}/.match table
          PointHistory.table_name = table
          PointHistory.where(point_id: point_id).each do |point_history|
            point_histories << point_history
          end
        end
      end
    end
    point_histories.sort.reverse
  end

  def self.find_by_device_id device_id
    point_histories = []
    ActiveRecord::Base.connection.tables.each do |table|
      if /point_histories_\d{6}/.match table
        PointHistory.table_name = table
        PointHistory.where(device_id: device_id).each do |point_history|
          point_histories << point_history
        end
      end
    end
    point_histories
  end

  def self.keyword(start_time, end_time, point_id)

    point_histories = find_by_point_id(point_id)

    return point_histories[0..19] if start_time.blank? && end_time.blank?

    devices = point_histories.select { |phs| (start_time..end_time).cover? phs.created_at }
    devices[0..19]

    # find_by_point_id(point_id).each do |p|
    #   created_time = p.created_at.to_datetime
    #   if start_time.to_datetime <= created_time && created_time - 1.day <= end_time.to_datetime
    #     devices << p
    #   end
    # end
    # devices[0..19]
  end

  #默认数据
  #返回[[值1, 值2, 值3],[时间1, 时间2, 时间3]]
  def self.default_result
    default_array = []
    month = DateTime.now.strftime("%Y%m")
    dhs = PointHistory.proxy(month: month).limit(20)
    dds = PointHistory.where({id: dhs.collect{|x| x.id.to_i}}).collect{|x| x.point_value.to_i}
    dts = PointHistory.where({id: dhs.collect{|x| x.id.to_i}}).collect{|x| x.created_at.strftime("%Y-%m-%d %H:%M:%S")}
    default_array = [dds, dts]
  end

  #默认数据
  #默认返回PointHistory的20个对象
  def self.default_result_hash
    month = DateTime.now.strftime("%Y%m")
    result = PointHistory.proxy(month: month).limit(20)
    result
  end

  #检索数据,返回PointHistory对象集合
  def self.result_by_hash start_time, end_time, point_id
    phs = []
    if start_time.present? && end_time.present? && (end_time.to_date - start_time.to_date) > 1.month
      months = (end_time.to_date..start_time.to_date).map{|d| [d.year.to_s + PointHistory.format_month(d.month)] }.uniq
      months.each do |month|
        phs << PointHistory.proxy(month: month).keyword(start_time, end_time, point_id)
      end
    else
      phs = PointHistory.proxy(month: DateTime.now.strftime("%Y%m")).keyword(start_time, end_time, point_id)
    end

    if phs.length <= 20
      point_histories = PointHistory.where({id: phs.collect{|x| x.id.to_i}})
    elsif 20 < phs.length <= 100
      point_histories = PointHistory.where({id: phs.collect{|x| x.id.to_i%4 == 0}})
    elsif 100 < phs.length <= 1000
      point_histories = PointHistory.where({id: phs.collect{|x| x.id.to_i%50 == 0}})
    elsif 1000 < phs.length <= 10000
      point_histories = PointHistory.where({id: phs.collect{|x| x.id.to_i%500 == 0}})
    elsif 10000 < phs.length <= 100000
      point_histories = PointHistory.where({id: phs.collect{|x| x.id.to_i%5000 == 0}})
    end
    point_histories
  end

  #ids目的是为导出时查询PointHistory集合提供id数组
  def self.result_by_sorts start_time, end_time, point_id
    result_array = []
    phs = []

    if start_time.present? && end_time.present? && (end_time.to_date - start_time.to_date) > 1.month
      months = (end_time.to_date..start_time.to_date).map{|d| [d.year.to_s + PointHistory.format_month(d.month)] }.uniq
      p months
      months.each do |month|
        phs << PointHistory.proxy(month: month).keyword(start_time, end_time, point_id)
      end
    else
      phs = PointHistory.proxy(month: DateTime.now.strftime("%Y%m")).keyword(start_time, end_time, point_id)
    end

    if phs.length <= 20
      pds = PointHistory.where({id: phs.collect{|x| x.id.to_i}}).collect{|x| x.point_value.to_i}
      pts = PointHistory.where({id: phs.collect{|x| x.id.to_i}}).collect{|x| x.created_at.strftime("%Y-%m-%d-%H:%M:%S")}
      ids = PointHistory.where({id: phs.collect{|x| x.id.to_i}}).collect{|x| x.id.to_i}
    elsif 20 < phs.length <= 100
      pds = PointHistory.where({id: phs.collect{|x| x.id.to_i%4 == 0}}).collect{|x| x.point_value.to_i}
      pts = PointHistory.where({id: phs.collect{|x| x.id.to_i%4 == 0}}).collect{|x| x.created_at.strftime("%Y-%m-%d-%H:%M:%S")}
      ids = PointHistory.where({id: phs.collect{|x| x.id.to_i}}).collect{|x| x.id.to_i}
    elsif 100 < phs.length <= 1000
      pds = PointHistory.where({id: phs.collect{|x| x.id.to_i%50 == 0}}).collect{|x| x.point_value.to_i}
      pts = PointHistory.where({id: phs.collect{|x| x.id.to_i%50 == 0}}).collect{|x| x.created_at.strftime("%Y-%m-%d-%H:%M:%S")}
      ids = PointHistory.where({id: phs.collect{|x| x.id.to_i}}).collect{|x| x.id.to_i}
     elsif 1000 < phs.length <= 10000
      pds = PointHistory.where({id: phs.collect{|x| x.id.to_i%500 == 0}}).collect{|x| x.point_value.to_i}
      pts = PointHistory.where({id: phs.collect{|x| x.id.to_i%500 == 0}}).collect{|x| x.created_at.strftime("%Y-%m-%d-%H:%M:%S")}
      ids = PointHistory.where({id: phs.collect{|x| x.id.to_i}}).collect{|x| x.id.to_i}
    elsif 10000 < phs.length <= 100000
      pds = PointHistory.where({id: phs.collect{|x| x.id.to_i%5000 == 0}}).collect{|x| x.point_value.to_i}
      pds = PointHistory.where({id: phs.collect{|x| x.id.to_i%5000 == 0}}).collect{|x| x.created_at.strftime("%Y-%m-%d-%H:%M:%S")}
      ids = PointHistory.where({id: phs.collect{|x| x.id.to_i}}).collect{|x| x.id.to_i}
    end
    result_array = [pds, pts, ids]
  end

  def reports(start_time_str, end_time_str, points)
    start_time = DateTime.parse(start_time_str) - 8.hour
    end_time = DateTime.parse(end_time_str) - 8.hour
    sql = ActiveRecord::Base.connection()

    if start_time.month == end_time.month
      query_str = "select p1.* from point_histories_#{start_time.strftime('%Y%m')} as p1 where p1.created_at between '#{start_time.strftime('%Y-%m-%d %H:%M:00')}' and '#{end_time.strftime('%Y-%m-%d %H:%M:00')}' and p1.point_id in (#{points})"
    else
      query_str = "select p1.* from point_histories_#{start_time.strftime('%Y%m')} as p1 where p1.created_at > '#{start_time.strftime('%Y-%m-%d %H:%M:00')}' and p1.point_id in (#{points})"
      query_str << "union"
      query_str << "select p2.* from point_histories_#{end_time.strftime('%Y%m')} as p2 where p2.created_at < '#{end_time.strftime('%Y-%m-%d %H:%M:00')}' and p2.point_id in (#{points});"
    end
    result = sql.select_all query_str
    result.rows
  end

  def self.format_month month
    month.to_s.length == 2 ? month.to_s : "0"+month.to_s
  end
end
