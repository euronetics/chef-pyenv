class Chef
  module Pyenv
    module ScriptHelpers
      def pyenv_root
        if new_resource.root_path
          new_resource.root_path
        elsif new_resource.user
          ::File.join(user_home, '.pyenv')
        else
          node['pyenv']['root_path']
        end
      end

      def user_home
        return nil unless new_resource.user

        Etc.getpwnam(new_resource.user).dir
      end

      def which_rbenv
        "(#{new_resource.user || 'system'})"
      end

      def current_global_version
        version_file = ::File.join(rbenv_root, 'version')

        ::File.exists?(version_file) && ::IO.read(version_file).chomp
      end

      def wrap_shim_cmd(cmd)
        [ %{export RBENV_ROOT="#{rbenv_root}"},
          %{export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"},
          %{export RBENV_VERSION="#{new_resource.rbenv_version}"},
          %{$RBENV_ROOT/shims/#{cmd}}
        ].join(' && ')
      end
    end
  end
end