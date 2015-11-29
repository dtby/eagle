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
			'能效' => 'fa-bar-chart', '部署' => 'fa-desktop', '报表' => 'fa-files-o', '告警记录' => 'fa-list-ul'
		}
		icons[menu] || 'fa-home'
	end
end
