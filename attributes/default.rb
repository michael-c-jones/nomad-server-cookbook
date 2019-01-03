

default['nginx']['conf_cookbook']        = 'nomad-server'
default['nginx']['conf_template']        = 'nginx.conf.erb'
default['nginx']['default_site_enabled'] = false
default['nginx']['worker_processes']     = '6'
default['nginx']['worker_connections']   = '1024'
default['nginx']['enable-access-log']    = 'true'
default['nginx']['logrotate-path']       = "/etc/logrotate.d/nginx"


default['nomad-server'].tap do |nomad|

  nomad['system-packages']     = %w() 
  nomad['version']             = '0.8.5'
	nomad['service-port']        = '4646'
	nomad['ui-port']             = '4646'
	nomad['consul-service-name'] = 'nomad'
	nomad['log-level']           = 'INFO'
	nomad['acl-enabled']         = 'true'
	nomad['nginx-ports']         = %w(80)
	nomad['nginx-site']          = 'nomad'
	nomad['nginx-site-path']     = "#{node['nginx']['dir']}/sites-available/#{nomad['nginx-site']}"
	nomad['nginx-api-site']      = 'nomad-api'
	nomad['api-port']            = '4646'
	nomad['nginx-api-site-path'] = "#{node['nginx']['dir']}/sites-available/#{nomad['nginx-api-site']}"
	nomad['nginx-conf-path']     = "#{node['nginx']['dir']}/conf.d/nomad-service.conf"
	nomad['nginx-htpasswd-file'] = "#{node['nginx']['dir']}/htpasswd"
	nomad['backup-script']       = '/usr/local/bin/nomad-backup.sh'
	nomad['backup-hours']        = '2,10,18'
  nomad['acl-enabled']         = true

  # oauth stuff
	nomad['oauth']['github-org']    = 'YOUR-GITHUB-ORG-HERE'
	nomad['oauth']['listen-port']   = ':8080'
	nomad['oauth']['upstream-url']  = 'http://127.0.0.1:80/'
	nomad['oauth']['client-id']     = ''
	nomad['oauth']['client-secret'] = ''
	nomad['oauth']['cookie-expiry'] = '1h'
	nomad['oauth']['user']          = 'www-data'
	nomad['oauth']['group']         = 'www-data'
	nomad['oauth']['env']           = {}
	nomad['oauth']['binary']        = '/usr/local/bin/oauth-proxy'
	nomad['oauth']['config']        = '/etc/oauth.cfg'

end
