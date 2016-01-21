System.destroy_all
System.create!([
  { id: 1, sys_name: '动力' },
  { id: 2, sys_name: '环境' },
  { id: 3, sys_name: '联动' },
  { id: 4, sys_name: '安全' },
  { id: 5, sys_name: '远程' },
  { id: 6, sys_name: '能效' },
  { id: 7, sys_name: '部署' }
])

SubSystem.destroy_all
SubSystem.create!([
  { id: 1, system_id: 1, name: 'UPS系统' },
  { id: 2, system_id: 1, name: '电量仪系统' },
  { id: 3, system_id: 1, name: '电表系统' },
  { id: 4, system_id: 1, name: '电池检测' },
  { id: 5, system_id: 1, name: '发电机系统' },

  { id: 6, system_id: 2, name: '温湿度系统' },
  { id: 7, system_id: 2, name: '机柜环境' },
  { id: 8, system_id: 2, name: '空调系统' },
  { id: 9, system_id: 2, name: '漏水系统' },

  { id: 10, system_id: 4, name: '消防系统' },
  { id: 11, system_id: 4, name: '氢气检测' }
])
# SubSystem.create!([
#   { id: 1, system_id: 1, name: '配电系统' },
#   { id: 2, system_id: 1, name: 'UPS系统' },
#   { id: 3, system_id: 1, name: '电池' },
#   { id: 4, system_id: 1, name: '配电柜' },
#   { id: 5, system_id: 1, name: '机柜动力' },
#   { id: 6, system_id: 1, name: '发电机' },
#   { id: 13, system_id: 1, name: '空调系统' },
#   { id: 10, system_id: 1, name: '电量仪系统' },
#   { id: 16, system_id: 1, name: '电表' },
#   { id: 7, system_id: 2, name: '温湿度系统' },
#   { id: 8, system_id: 2, name: '精密空调' },
#   { id: 9, system_id: 2, name: '漏水检测' },
#   { id: 11, system_id: 2, name: '机柜环境' },
#   { id: 12, system_id: 2, name: '风冷系统' },
#   { id: 15, system_id: 2, name: '漏水系统' },
#   { id: 14, system_id: 4, name: '消防系统' }
# ])
# {"配电系统"=>nil, "UPS系统"=>"GAFC", "空调系统"=>"7053",
# "温湿度系统"=>"th802", "电量仪系统"=>"UMW450", "风冷系统"=>"威图",
# "温湿度系统"=>"普通温湿度", "消防系统"=>"7053", "漏水系统"=>"7053", nil=>nil}
Pattern.destroy_all
Pattern.create!([
  { id: 1, sub_system_id: 1, name: 'GAFC', partial_path: 'gafc' },    # "UPS系统"=>"GAFC",
  { id: 2, sub_system_id: 2, name: 'UMW450', partial_path: 'elec_meter_umw450' }, # "电量仪系统"=>"UMW450",
  { id: 3, sub_system_id: 1, name: '配电', partial_path: 'power' },   # "配电系统"=>nil,

  { id: 4, sub_system_id: 8, name: '威图列间空调', partial_path: 'weitu' },
  { id: 5, sub_system_id: 8, name: '7053', partial_path: 'air_c_7053' },  # "空调系统"=>"7053",
  { id: 6, sub_system_id: 8, name: '威图', partial_path: 'cool_sys_weitu' },  #"风冷系统"=>"威图",
  { id: 7, sub_system_id: 9, name: '7053', partial_path: 'leaking_7053' },  # "漏水系统"=>"7053", nil=>nil}

  { id: 9, sub_system_id: 10, name: '7053', partial_path: 'fire_7053' },  # "消防系统"=>"7053", nil=>nil}

  { id: 10, sub_system_id: 6, name: '普通温湿度', partial_path: 'commen_temp' }, # "温湿度系统"=>"普通温湿度" and "th802",
])

# Pattern.create!([
#   { id: 1, sub_system_id: 1, name: '配电', partial_path: 'power' },   # "配电系统"=>nil,
#   { id: 2, sub_system_id: 2, name: 'GAFC', partial_path: 'gafc' },    # "UPS系统"=>"GAFC",
#   { id: 3, sub_system_id: 13, name: '7053', partial_path: 'air_c_7053' },  # "空调系统"=>"7053",
#   { id: 4, sub_system_id: 10, name: 'UMW450', partial_path: 'elec_meter_umw450' }, # "电量仪系统"=>"UMW450",
#   { id: 5, sub_system_id: 12, name: '威图', partial_path: 'cool_sys_weitu' }, # "风冷系统"=>"威图",
#   { id: 6, sub_system_id: 7, name: '普通温湿度', partial_path: 'commen_temp' }, # "温湿度系统"=>"普通温湿度" and "th802",
#   { id: 7, sub_system_id: 14, name: '7053', partial_path: 'fire_7053' }, # "消防系统"=>"7053",
#   { id: 8, sub_system_id: 15, name: '7053', partial_path: 'leaking_7053' },  # "漏水系统"=>"7053", nil=>nil}
#   { id: 9, sub_system_id: 13, name: '威图列间空调', partial_path: 'weitu' },
#   { id: 10, sub_system_id: 16, name: '泰昂IPM', partial_path: 'dianliu' }
# ])
