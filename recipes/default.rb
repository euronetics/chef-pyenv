

Array(node['pyenv']['install_pkgs']).each do |pkg|
  package pkg do
    action :install
  end
end

# Should be a dynamic user
home_path = File.expand_path("~#{node['pyenv']['user']}")

git "#{home_path}/.pyenv" do
  repository node['pyenv']['git_url']
  user node['pyenv']['user']
  group node['pyenv']['user']
  action :sync
end

pyenv_bin = "#{home_path}/.pyenv/bin"
pyenv_version_bin = "#{home_path}/.pyenv/versions/3.3.2/bin"

Array(node['pyenv']['pythons']).each do |python_ver|
  pyenv_script "pyenv install Python #{python_ver}" do
    user node['pyenv']['user']
    group node['pyenv']['user']
    cwd "#{home_path}"
    root_path "#{home_path}/.pyenv"
    #code "pyenv install 3.3.2"
    code <<-EOH
    pyenv install #{python_ver}
    pyenv rehash
    EOH
    not_if {File.directory?('#{home_path}/.pyenv/versions/#{python_ver}')}
  end
end

node['pyenv']['packages'].each_pair do |python_version, pkgs|
  Array(pkgs).each do |pkg|
    pyenv_pip pkg['name'] do
      user node['pyenv']['user']
      pyenv_version "#{python_version}"
      root_path "#{home_path}/.pyenv"
      package_name pkg['name']
      version pkg['version']
      action :install
      #Should do something here...
    end
  end
end


=begin

rescue  => e

end
bash "Setup-pyenv-and-install-python3.3-and-Django" do
  user node['pyenv']['user']
  group node['pyenv']['user']
  cwd "#{home_path}"
  code <<-EOH

  #{pyenv_bin}/pyenv install 3.3.2;
  #{pyenv_bin}/pyenv rehash;
  #{pyenv_bin}/pyenv local 3.3.2;
  #{pyenv_bin}/pyenv rehash;

  #{pyenv_version_bin}/pip install Django==1.5.1;
  #{pyenv_bin}/pyenv rehash;
  #{pyenv_version_bin}/pip install psycopg2;
  #{pyenv_bin}/pyenv rehash;
  EOH
end
=end