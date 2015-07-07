describe 'mysql-wrapper::server' do
  context 'with default configuration' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'redhat', version: '6.6').converge(described_recipe)
    end

    it 'installs a mysql server' do
      expect(chef_run).to create_mysql_service('default')
    end

    it 'starts a mysql server' do
      expect(chef_run).to create_mysql_service('default').with(action: [:create, :start])
    end

    it 'sets the configured port' do
      expect(chef_run).to create_mysql_service('default').with(port: '3306')
    end

    it 'sets the install version' do
      expect(chef_run).to create_mysql_service('default').with(version: '5.5')
    end

    it 'sets the root password' do
      expect(chef_run).to create_mysql_service('default').with(initial_root_password: '')
    end

    it 'sets the data directory' do
      expect(chef_run).to create_mysql_service('default').with(data_dir: nil)
    end

    it 'places a legacy config file' do
      expect(chef_run).to create_mysql_config('legacy').with(source: 'legacy_my.cnf.erb')
    end

  end

  context 'with overridden configuration' do

    let(:chef_run) do

      ChefSpec::SoloRunner.new do |node|
        node.set['mysql'] = {
          :port => 1234,
          :version => 'version.number',
          :server_root_password => 'password1',
          :data_dir => '/foo/data'
        }
      end.converge(described_recipe)
    end

    it 'sets the configured port' do
      expect(chef_run).to create_mysql_service('default').with(port: '1234')
    end

    it 'sets the install version' do
      expect(chef_run).to create_mysql_service('default').with(version: 'version.number')
    end

    it 'sets the root password' do
      expect(chef_run).to create_mysql_service('default').with(initial_root_password: 'password1')
    end

    it 'sets the data directory' do
      expect(chef_run).to create_mysql_service('default').with(data_dir: '/foo/data')
    end

  end
end
