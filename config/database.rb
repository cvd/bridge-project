MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'bridge_project_dev'
  when :production  then MongoMapper.database = 'bridge_production'
  when :test        then MongoMapper.database = 'bridge_test'
end
