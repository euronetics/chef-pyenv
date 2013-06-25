

action :install do
  script_code = create_pip_install_code

  script new_resource.name do
    interpreter   "bash"
    code          script_code
    user          new_resource.user if new_resource.user
    cwd           "#{new_resource.root_path}/versions/#{new_resource.pyenv_version}/bin"
  end
end

private

def create_pip_install_code
  script = []
  if new_resource.version
    script << %W[ ./pip install #{new_resource.package_name}==#{new_resource.version} ]
  else
    script << %W[ ./pip install #{new_resource.package_name} ]
  end
  script.join(" ")
end