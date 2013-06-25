actions :install

attribute :package_name,    :kind_of => String, :name_attribute => true
attribute :pyenv_version,   :kind_of => String
attribute :version,         :kind_of => String
attribute :user,            :kind_of => String
attribute :root_path,       :kind_of => String

def initialize(*args)
  super
  @action = :install
end