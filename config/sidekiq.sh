x=`ps aux | grep sidekiq | grep -v grep | awk '{print $2}'`;
kill $x;
cd /home/deploy/eagle && bundle exec sidekiq -d -C config/sidekiq.yml -e production;