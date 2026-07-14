# config/routes.rb

require File.expand_path('../../app/controllers/application_controller', __FILE__)


controllers_path = File.expand_path('../../app/controllers', __FILE__)
Dir.glob("#{controllers_path}/*_controller.rb").each do |controller_file|
  require controller_file unless controller_file.end_with?('application_controller.rb')
end