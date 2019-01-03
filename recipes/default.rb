
node['nomad-server'].tap do |nomad|

	nomad['system-packages'].each do |pkg|
	  package pkg
	end
	
	
	include_recipe "iptables"
	iptables_rule '40-nomad-ports'
	
	node.default['nomad']['package']  = "#{nomad['version']}/nomad_#{nomad['version']}_linux_amd64.zip"
	node.default['nomad']['checksum'] = ''
	node.default['nomad']['daemon_args']['node'] = node['ec2']['tags']['Name']
	
	include_recipe 'nomad'
	
	nomad_config '00-localhost' do
	  datacenter nomad['config']['datacenter']
	  region     nomad['config']['region'] 
	  data_dir   nomad['data-dir']
	  log_level  nomad['log-level']
	  notifies   :restart, 'service[nomad]', :delayed
	end
	
	qualified_server_service = "#{nomad['server-service-name']}-#{nomad['config']['id']}"
	qualified_client_service = "#{nomad['client-service-name']}-#{nomad['config']['id']}"
	
	nomad_consul_config '00-localhost' do
	  address             nomad['consul-address']
	  server_service_name qualified_server_service
	  client_service_name qualified_client_service
	  notifies :restart, 'service[nomad]', :delayed
	end
	
	nomad_server_config '00-localhost' do
	  enabled          true
	  bootstrap_expect nomad['bootstrap-expect']
	  notifies :restart, 'service[nomad]', :delayed
	end
	
	nomad_client_config '00-localhost' do
	  enabled  false
	  notifies :restart, 'service[nomad]', :delayed
	end
	
	nomad_telemetry_config '00-localhost' do
	  datadog_address nomad['datadog-address'] 
	  datadog_tags    [ "id:#{nomad['config']['id']}",
	                    "datacenter:#{nomad['config']['datacenter']}",
	                    "region:#{nomad['config']['region']}" ]
	  notifies :restart, 'service[nomad]', :delayed
	end

	nomad_acl_config '00-localhost' do
	  enabled  nomad['acl-enabled']
	  notifies :restart, 'service[nomad]', :delayed
	end
	
	include_recipe "nomad-server::nginx"
	include_recipe "nomad-server::oauth"
	
	tag("bootstrapped")

end
