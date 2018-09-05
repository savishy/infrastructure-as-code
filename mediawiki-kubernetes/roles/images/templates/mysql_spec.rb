control 'mysql0' do
  impact 1.0
  title 'mysql server connection'
  desc 'mysql server should accept connections'
end

control 'mysql1' do
  impact 0.7
  title 'mysql database for mediawiki'
  desc 'mysql db for mediawiki should be present with the correct schema.'
end
