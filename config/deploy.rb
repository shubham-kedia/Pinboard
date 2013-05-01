set :application, 'Pinboard'
set :scm, :git
set :repository, "git@github.com:pSenthil202/pinboard.git"
set :user, "root"
set :scm_passphrase, ""
set :branch, "master"
set :deploy_via, :remote_cache
require 'capistrano/ext/multistage'
set :stages, ["staging", "development", "production"]
set :default_stage, "development"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true