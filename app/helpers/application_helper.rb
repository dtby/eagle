module ApplicationHelper
	def alert_name(name)
		case name
		when "notice"
			"success"
		when "alert"
			"danger"
		else
			"info"
		end
	end

	# 左侧菜单栏对应图标
	def menu_tree_icon(menu)
		icons = { 
			'动力' => 'fa-paper-plane', '环境' => 'fa-globe', '联动' => 'fa-sitemap', '安全' => 'fa-check', '远程' => 'fa-cloud', 
			'能效' => 'fa-bar-chart', '部署' => 'fa-desktop'
		}
		icons[menu] || 'fa-home'
	end

  #告警类型
	# def alarm_status status
 #    case status
 #    when 1
 #    	"告警"
 #    when 0
 #    	"设备正常"
 #    end
	# end

  #格式化小数
  def number_format number
    '%.1f' % number.to_f
  end

  #格式化报表名称
  def format_report_name name
    if name.to_s.include?("-")
      name.split("-")[1]
    else
      name
    end
  end

end
