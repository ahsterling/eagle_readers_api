# config valid only for current version of Capistrano
require 'dotenv'
Dotenv.load
lock '3.3.5'

set :application, 'eagle-readers-api'
set :repo_url, 'git@github.com:ahsterling/eagle_readers_api.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
set :default_env, {
  'DEVISE_SECRET_KEY'=> ENV["DEVISE_SECRET_KEY"],
  'S3_KEY' => ENV["S3_KEY"],
  'S3_SECRET' => ENV['S3_SECRET'],
  'S3_BUCKET_NAME' => ENV['S3_BUCKET_NAME']
  }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :use_sudo, false

set :deploy_to, '/var/www/eagle-readers-api'

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web, :app, :db), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
