require File.dirname(__FILE__) + "/Frontend"
set :root, File.expand_path(File.dirname(__FILE__) + '/')
set :app_file, File.expand_path(File.dirname(__FILE__) + '/lib/Frontend.rb')
set :public,   File.expand_path(File.dirname(__FILE__) + '/lib/public')
set :views,    File.expand_path(File.dirname(__FILE__) + '/lib/views')
set :env,      :production
disable :run, :reload
run Sinatra::Application
