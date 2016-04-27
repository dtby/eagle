class Report

  # 导出查询结果到Excel
  # datas结构:
  # {
  #   point_name1: [[date_time, value]],
  #   point_name2: [[date_time, value]]
  # }
  def write_to_excel room_id, datas
    now_date = DateTime.now.to_date
    file_dir = "public/rooms/#{room_id}/reports/"

    FileUtils.makedirs(file_dir) unless File.exist?(file_dir)
    file_name = "#{now_date}.xls"
    output_hash = {}
    datas.each do |key, data|
      data.each do |date_time, value|
        output_hash ||= {}
        output_hash[date_time] ||= {}
        output_hash[date_time][key] = value
      end
    end

    p = Axlsx::Package.new
    p.workbook.add_worksheet(:name => '设备报表') do |sheet|
      sheet.add_row ["时间"].concat datas.keys
      output_hash.each do |date_time, o|
        sheet.add_row [date_time].concat o.values
      end
      p.use_shared_strings = true
      p.serialize(file_dir << file_name)
    end
    file_name
  end
end
