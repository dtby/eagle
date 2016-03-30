x=`ps aux | grep sidekiq | grep -v grep | awk '{print $2}'`; [ "$x" == "" ] && cd /home/deploy/eagle && bundle exec sidekiq -d -L ./log/sidekiq.log -C config/sidekiq.yml -e production
