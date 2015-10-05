set :application, "set your application name here"
set :repository,  "set your repository location here"

set :unicorn_conf, "#{current_path}/config/unicorn/production.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/production.pid"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"

# 유니콘의 기동, 종료, 다시 불러오기의 작업을 기술
namespace :unicorn do
  task :start, :roles => :app do
    run <<-CMD
    cd #{current_path};
    BUNDLE_GEMFILE="#{current_path}/Gemfile" bundle exec unicorn_rails -c #{unicorn_conf} -E #{rail_env} -D;
    CMD
  end
  task :stop, :roles => :app do
    run "kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app do
    run "kill -QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app do
    run "kill -USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app do
    run "kill `cat #{unicorn_pid}`"
    run <<-CMD
    cd #{current_path};
    BUNDLE_GEMFILE="#{current_path}/Gemfile" bundle exec unicorn_rails -c #{unicorn_conf} -E #{rail_env} -D
    CMD
  end
end

# 배포시에 자동으로 유니콘을 기동한다
after "deploy:start",   "unicorn:start"
after "deploy:stop",    "unicorn:stop"
after "deploy:restart", "unicorn:reload"


