System.destroy_all
System.create!([
  { id: 1, sys_name: '动力' }, 
  { id: 2, sys_name: '环境' },
  { id: 3, sys_name: '联动' },
  { id: 4, sys_name: '安全' },
  { id: 5, sys_name: '远程' },
  { id: 6, sys_name: '能效' },
  { id: 7, sys_name: '部署' },
  { id: 8, sys_name: '报表' },
  { id: 9, sys_name: '告警记录' }
])

SubSystem.destroy_all
SubSystem.create!([
  { id: 1, system_id: 1, name: '配电' }, 
  { id: 2, system_id: 1, name: 'UPS' },
  { id: 3, system_id: 1, name: '配电柜' },
  { id: 4, system_id: 1, name: '电池' },
  { id: 5, system_id: 1, name: '机柜动力' },
  { id: 6, system_id: 1, name: '发电机' },
  { id: 7, system_id: 1, name: '温湿度' },
  { id: 8, system_id: 1, name: '精密空调' },
  { id: 9, system_id: 1, name: '漏水检测' },
  { id: 10, system_id: 6, name: '全年能耗' },
  { id: 11, system_id: 6, name: '漏水检测' }
])


Pattern.destroy_all
Pattern.create!([
  { id: 1, sub_system_id: 1, name: '配电1', partial_path: 'power_1' }, 
  { id: 2, sub_system_id: 1, name: '配电2', partial_path: 'power_2' },
  { id: 3, sub_system_id: 2, name: 'UPS1', partial_path: 'ups_1' },
  { id: 4, sub_system_id: 2, name: 'UPS2', partial_path: 'ups_2' }
])
