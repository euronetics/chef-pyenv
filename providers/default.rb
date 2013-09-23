action :install do

  user = new_resource.user
  group = new_resource.group or user
  install_pyenv user, group
  install_pyenv_py user, group, new_resource.version
end

private

def install_pyenv(user, group)
  Array(node['pyenv']['install_pkgs']).each do |pkg|
    package pkg do
      action :install
    end
  end

  home_path = ::File.expand_path("~#{user}")

  git "#{home_path}/.pyenv" do
    repository node['pyenv']['git_url']
    user user
    group group
    action :sync
  end
end

def install_pyenv_py(user, group, version)
  home_path = ::File.expand_path("~#{user}")

  pyenv_script "pyenv install Python #{version}" do
    user user
    group group
    cwd "#{home_path}"
    root_path "#{home_path}/.pyenv"
    #code "pyenv install 3.3.2"
    code <<-EOH
    pyenv install #{version}
    pyenv rehash
    EOH
    not_if {::File.directory?("#{home_path}/.pyenv/versions/#{version}")}
  end
end
