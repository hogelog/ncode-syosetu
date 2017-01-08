DIRS = %w(
  ncode-syosetu-core
  ncode-syosetu-epub3
  ncode-syosetu-mobi
  ncode-syosetu-ssml
  ncode-syosetu-polly
  ncode-syosetu
)

DIRS.each do |dir|
  %w(install spec release).each do |task_name|
    desc "#{dir}: rake #{task_name}"
    task "#{dir}:#{task_name}" do
      Dir.chdir(dir) do
        sh "bundle", "exec", "rake", task_name.to_s
      end
    end
  end

  desc "#{dir}: bundle:install"
  task "#{dir}:bundle:install" do
    Dir.chdir(dir) do
      sh "bundle", "install"
    end
  end
end

namespace :all do
  %w(install spec release bundle:install).each do |task_name|
    desc "#{task_name}"
    task task_name => DIRS.map{|dir| "#{dir}:#{task_name}" }
  end
end

desc "install"
task "install" => DIRS.map{|dir| ["#{dir}:bundle:install", "#{dir}:install"] }.flatten

task :default => "all:spec"
