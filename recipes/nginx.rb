# install nginx

iptables_rule '45-nginx-ports'


include_recipe 'chef_nginx::default'
include_recipe 'chef_nginx::http_stub_status_module'


template "#{node['nomad-server']['nginx-site-path']}" do
  source   'nomad-server.conf.erb'
  owner    node['nginx']['user']
  group    node['nginx']['group']
  mode     '0644'
  notifies :enable, "nginx_site[#{node['nomad-server']['nginx-site']}]", :immediately
  notifies :reload,  'service[nginx]', :delayed
end

template "#{node['nomad-server']['nginx-api-site-path']}" do
  source   'nomad-server-api.conf.erb'
  owner    node['nginx']['user']
  group    node['nginx']['group']
  mode     '0644'
  notifies :enable, "nginx_site[#{node['nomad-server']['nginx-api-site']}]", :immediately
  notifies :reload,  'service[nginx]', :delayed
end


nginx_site "#{node['nomad-server']['nginx-site']}" do
  enable true
  action  :nothing
end

nginx_site "#{node['nomad-server']['nginx-api-site']}" do
  enable true
  action  :nothing
end

cookbook_file "#{node['nginx']['logrotate-path']}" do
  source 'nginx-logrotate'
  owner  'root'
  group  'root'
  mode   '0644'
end
