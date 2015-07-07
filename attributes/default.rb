is_cloud = node.attribute?('cloud') && node['cloud']['local_ipv4']
cpus_undefined = node['cpu'].nil? || node['cpu']['total'].nil?
total_cpus = cpus_undefined ? '8' : (node['cpu']['total'].to_i * 2).to_s

default['mysql']['port'] = 3306
default['mysql']['version'] = '5.5'
default['mysql']['server_root_password'] = ''
default['mysql']['data_dir'] = nil # nil allows the wrapped cookbook to use it's own defaults

default['mysql']['nice'] = 0

default['mysql']['bind_address'] = is_cloud ? node['cloud']['local_ipv4'] : node['ipaddress']

default['mysql']['auto-increment-increment'] = 1
default['mysql']['auto-increment-offset'] = 1

default['mysql']['innodb_status_file'] = false
default['mysql']['log_files_in_group'] = false


default['mysql']['tunable']['back_log'] = '128'
default['mysql']['tunable']['binlog_cache_size'] = '32K'
default['mysql']['tunable']['character-set-server'] = 'utf8'
default['mysql']['tunable']['collation-server'] = 'utf8_general_ci'
default['mysql']['tunable']['concurrent_insert'] = '2'
default['mysql']['tunable']['connect_timeout'] = '10'
default['mysql']['tunable']['expire_logs_days'] = 10
default['mysql']['tunable']['innodb_additional_mem_pool_size'] = '8M'
default['mysql']['tunable']['innodb_buffer_pool_instances'] = '4'
default['mysql']['tunable']['innodb_buffer_pool_size'] = '128M'
default['mysql']['tunable']['innodb_commit_concurrency'] = total_cpus
default['mysql']['tunable']['innodb_data_file_path'] = 'ibdata1:10M:autoextend'
default['mysql']['tunable']['innodb_data_home_dir'] = nil
default['mysql']['tunable']['innodb_file_per_table'] = true
default['mysql']['tunable']['innodb_flush_log_at_trx_commit'] = '1'
default['mysql']['tunable']['innodb_flush_method'] = false
default['mysql']['tunable']['innodb_io_capacity'] = '200'
default['mysql']['tunable']['innodb_lock_wait_timeout'] = '60'
default['mysql']['tunable']['innodb_log_buffer_size'] = '8M'
default['mysql']['tunable']['innodb_log_file_size'] = '5M'
default['mysql']['tunable']['innodb_read_io_threads'] = total_cpus
default['mysql']['tunable']['innodb_support_xa'] = true
default['mysql']['tunable']['innodb_table_locks'] = true
default['mysql']['tunable']['innodb_thread_concurrency'] = total_cpus
default['mysql']['tunable']['innodb_write_io_threads'] = '4'
default['mysql']['tunable']['join_buffer_size'] = '128k'
default['mysql']['tunable']['key_buffer_size'] = '256M'
default['mysql']['tunable']['log_bin'] = nil
default['mysql']['tunable']['log_bin_trust_function_creators'] = false
default['mysql']['tunable']['log_error'] = false
default['mysql']['tunable']['log_queries_not_using_index'] = true
default['mysql']['tunable']['log_slave_updates'] = false
default['mysql']['tunable']['log_warnings'] = false
default['mysql']['tunable']['long_query_time'] = 2
default['mysql']['tunable']['lower_case_table_names'] = false
default['mysql']['tunable']['max_allowed_packet'] = '16M'
default['mysql']['tunable']['max_binlog_size'] = '100M'
default['mysql']['tunable']['max_connect_errors'] = '10'
default['mysql']['tunable']['max_connections'] = '800'
default['mysql']['tunable']['myisam_max_sort_file_size'] = '2147483648'
default['mysql']['tunable']['myisam-recover'] = 'BACKUP'
default['mysql']['tunable']['myisam_repair_threads'] = '1'
default['mysql']['tunable']['myisam_sort_buffer_size'] = '8M'
default['mysql']['tunable']['net_read_timeout'] = '30'
default['mysql']['tunable']['net_write_timeout'] = '30'
default['mysql']['tunable']['open-files-limit'] = '1024'
default['mysql']['tunable']['query_cache_limit'] = '1M'
default['mysql']['tunable']['query_cache_size'] = '16M'
default['mysql']['tunable']['read_buffer_size'] = '128k'
default['mysql']['tunable']['read_only'] = false
default['mysql']['tunable']['read_rnd_buffer_size'] = '256k'
default['mysql']['tunable']['relay_log'] = nil
default['mysql']['tunable']['relay_log_index'] = nil
default['mysql']['tunable']['replicate_do_db'] = nil
default['mysql']['tunable']['replicate_do_table'] = nil
default['mysql']['tunable']['replicate_ignore_db'] = nil
default['mysql']['tunable']['replicate_ignore_table'] = nil
default['mysql']['tunable']['replicate_wild_do_table'] = nil
default['mysql']['tunable']['replicate_wild_ignore_table'] = nil
default['mysql']['tunable']['server_id'] = nil
default['mysql']['tunable']['skip-character-set-client-handshake'] = false
default['mysql']['tunable']['skip-innodb-doublewrite'] = false
default['mysql']['tunable']['skip-name-resolve'] = false
default['mysql']['tunable']['skip_slave_start'] = false
default['mysql']['tunable']['slave_compressed_protocol'] = 0
default['mysql']['tunable']['sort_buffer_size'] = '2M'
default['mysql']['tunable']['sql_mode'] = false
default['mysql']['tunable']['sync_binlog'] = 0
default['mysql']['tunable']['table_cache'] = '128'
default['mysql']['tunable']['thread_cache_size'] = 8
default['mysql']['tunable']['thread_stack'] = '256K'
default['mysql']['tunable']['transaction-isolation'] = nil
default['mysql']['tunable']['tmp_table_size'] = '32M'
default['mysql']['tunable']['wait_timeout'] = '180'

default['mysql']['tunable']['bulk_insert_buffer_size'] = node['mysql']['tunable']['tmp_table_size']
default['mysql']['tunable']['max_heap_table_size'] = node['mysql']['tunable']['tmp_table_size']
default['mysql']['tunable']['table_open_cache'] = node['mysql']['tunable']['table_cache']

unless node['platform_family'] == 'rhel' && node['platform_version'].to_i < 6
  # older RHEL platforms don't support these options
  default['mysql']['tunable']['event_scheduler']  = 0
  default['mysql']['tunable']['binlog_format'] = 'statement' if node['mysql']['tunable']['log_bin']
end


default['mysql']['security']['chroot'] = nil
default['mysql']['security']['local_infile'] = nil
default['mysql']['security']['safe_user_create'] = nil
default['mysql']['security']['secure_auth'] = nil
default['mysql']['security']['secure_file_priv'] = nil
default['mysql']['security']['skip_show_database'] = nil
default['mysql']['security']['skip_symbolic_links'] = nil



case node['platform_family']
  when 'debian'
    default['mysql']['server']['basedir'] = '/usr'
    default['mysql']['server']['slow_query_log'] = 1
    default['mysql']['server']['slow_query_log_file']  = 'slow.log'
    default['mysql']['server']['skip_federated'] = false
    default['mysql']['tunable']['innodb_adaptive_flushing'] = false

  when 'freebsd'
    default['mysql']['server']['basedir'] = '/usr/local'

  when 'mac_os_x'
    default['mysql']['basedir'] = '/usr/local/Cellar'


  when 'rhel'
    default['mysql']['server']['basedir'] = '/usr'
    default['mysql']['server']['old_passwords'] = 1
    default['mysql']['server']['slow_query_log'] = 1
    default['mysql']['server']['slow_query_log_file']  = 'slow.log'
    default['mysql']['server']['skip_federated'] = false
    default['mysql']['tunable']['innodb_adaptive_flushing'] = false


  when 'suse'
    default['mysql']['server']['basedir'] = '/usr'
    default['mysql']['server']['old_passwords'] = 1
end
