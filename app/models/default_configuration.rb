class DefaultConfiguration
  def self.get(platform = :mac)
    app_name = 'myapp'
    user_name = 'vagrant'
    { vm_name: app_name,
      path: "/#{app_name}",
      git_branch: 'master',
      vm_os: 'ubuntu/trusty64',
      environments: ['development'],
      development: {
        target: 'virtualbox',
        autoconf: true,
        vm_memory: '1024',
        vm_swap: '1024',
        vm_cores: '2',
        vm_share_type: platform == :windows ? 'smb' : 'nfs',
        vm_ip: '192.168.20.50',
        vm_ports: {
          '0' => { guest: 80,  host: 8080 },
          '1' => { guest: 443, host: 8081 }
        },
      },
      staging: {
        target: 'server',
        port: '22',
      },
      production: {
        target: 'server',
        port: '22',
      },
      package_bundles: [ 'graphics', 'qt', 'curl' ],
      packages: [],
      manual_ruby_version: nil,
      server_name: 'localhost',
      rails_version: '4',
      ruby_install: 'rvm',
      ruby_version: '2.2.0',
      environment_file: "/#{app_name}/.envrc",
      databases: ['postgresql'],
      background_jobs: [],
      postgresql_orm: 'none',
      mysql_orm: 'none',
      mongodb_orm: 'none',
      redis_orm: 'none',
      mongodb_db_name: app_name,
      mysql_db_name: app_name,
      mysql_db_user: user_name,
      mysql_db_password: '',
      postgresql_db_name: app_name,
      postgresql_db_user: user_name,
      postgresql_db_password: '',
      postgresql_extensions: [ 'hstore' ],
      delayed_job_command: 'script/delayed_job run',
      sidekiq_command: 'sidekiq',
      resque_command: 'rake resque:work',
      server_type: 'nginx_unicorn' }
  end

  # Returns default configuration minimally required to compile
  # box templates. Includes everything but booleans. Hashes and arrays
  # are emptied.
  def self.base
    @base ||= cleanup(get)
  end

  def self.cleanup(hash)
    hash.each do |k, v|
      if [true, false].include?(v)
        hash.delete(k)
      elsif v.is_a?(Array)
        hash[k] = []
      elsif v.is_a?(Hash)
        if %i(development staging production).include?(k)
          cleanup(hash[k])
        else
          hash[k] = {}
        end
      end
    end
    hash
  end
end
