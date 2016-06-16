# !/usr/bin/env puma

require ::File.expand_path('../../config/environment',  __FILE__)
Rails.application.eager_load!

require 'action_cable/process/logging'

run ActionCable.server

# rails的运行环境
environment 'production'
threads 10, 128
workers 2

app_name = 'igrid_wechat_platform'
application_path = ""
directory application_path

pidfile "#{application_path}/tmp/pids/puma.pid"
state_path "#{application_path}/tmp/sockets/puma.state"
stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"
bind "unix://#{application_path}/tmp/sockets/#{app_name}.sock"
activate_control_app "unix://#{application_path}/tmp/sockets/pumactl.sock"

# 后台运行
daemonize true
on_restart do
  puts 'On restart...'
end
preload_app!


