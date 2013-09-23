

Array(node['pyenv']['install_pkgs']).each do |pkg|
  package pkg do
    action :install
  end
end

if node['pyenv']['user']
  pyenv node['pyenv']['version'] do
    user node['pyenv']['user']
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
      end
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