require 'rubygems'
require 'cloudfiles'

api_key = "41c5940ceddba2c17468e1b6f0745594"
user_name = "jdmontross"

cf = CloudFiles::Connection.new(:username => user_name, :api_key => api_key)
container = cf.container('mongo-backup')

#t = Time.now.utc.strftime("%Y-%m-%d")
t = Time.now.utc.strftime("%Y-%m-%d")
gzip_file_name = "bridge.#{t}-backup.tar.gz"
t = Time.now.utc.iso8601
cloudfiles_file_name = "bridge.#{t}-backup.tar.gz"
puts "trying to copy #{gzip_file_name}"

obj = container.create_object(cloudfiles_file_name)

obj.write(File.new("/data/backups/#{gzip_file_name}", "r").read)
