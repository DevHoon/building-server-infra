worker_processes 8 # 워커프로세스수
listen "/var/run/nginx-rails.sock" # 소켓파일 
pid    "/var/run/nginx-rails.pid"  # pid 파일

# 표준출력, 표준에러의 출력위치
stdout_path "./log/unicorn/production.log"
stderr_path "./log/unicorn/production.log"


#
# preload_app의 설정
#
preload_app true
        
before_fork do |server, worker|
  # 포크전에 데이터 베이스 접속을 끊는다
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 1
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

