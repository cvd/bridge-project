require 'rubygems'
require 'bacon'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bridge-project'
MongoMapper.database = "bridge_project_test"
Bacon.summary_on_exit


# puts Sinatra.settings