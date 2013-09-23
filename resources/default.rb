actions :install, :uninstall

attribute :version,         :kind_of => String, :name_attribute => true
attribute :user,            :kind_of => String, :required => true
attribute :group,            :kind_of => String
attribute :root_path,       :kind_of => String

def initialize(*args)
  super
  @action = :install
end
