require 'cocoapods'
require 'fileutils'

module CocoapodsGitHooks
  class GitHooksManager
    class << self
      # @return [Array<String>]
      def hook_types
        %w(applypatch-msg commit-msg fsmonitor-watchman post-update pre-applypatch pre-commit pre-merge-commit pre-push pre-rebase prepare-commit-msg push-to-checkout)
      end

      # @return [TargetDefinition]
      def abstract_target_of_githooks
        abstract_target = nil
        podfile = Pod::Config.instance.podfile
        podfile.target_definition_list.each do |target|
          if target.name == 'Githooks'
            abstract_target = target
            break
          end
        end unless podfile.target_definition_list.nil?

        if abstract_target.nil?
          Pod::UI.puts 'The abstract_target of SyncGithooks is not defined.'
          return nil
        end

        abstract_target
      end

      # @param [TargetDefinition]
      # @return [Array<Dependency>]
      def dependencies_in_target(abstract_target)
        abstract_target.dependencies
      end

      def validate_git_directory?
        unless File.directory?(".git")
          Pod::UI.puts 'Can not find .git directory.'
          return false
        end

        true
      end

      # @param [Array<Dependency>] dependencies
      def sync_githooks_in_dependencies(dependencies)
        pods_directory = "#{Dir.pwd}/Pods"
        hook_dependencies = Hash.new([])
        dependencies.each do |dependency|
          dependency_directory = if dependency.local?
                                   File.expand_path(dependency.external_source[:path])
                                 else
                                   "#{pods_directory}/#{dependency.name}"
                                 end
          hook_types.each { |hook_type|
            file_path = "#{dependency_directory}/githooks/#{hook_type}"
            if File.exist?(file_path)
              hook_dependencies[hook_type] += [dependency]
            end
          }
        end
        git_hook_directory = '.git/hooks'
        hook_dependencies.each_pair { |key, dependencies|
          file_path = "#{git_hook_directory}/#{key}"

          File.delete(file_path) if File.exist?(file_path)

          File.new(file_path, 'w')
          File.open(file_path, File::RDWR) do |file|
            file.write("#!/bin/sh\n")
            file.write("#!/usr/bin/env ruby\n")
            file.write("#!/usr/bin/env python\n")

            dependencies.each do |dependency|
              dependency_directory = if dependency.local?
                                       File.expand_path(dependency.external_source[:path])
                                     else
                                       "#{pods_directory}/#{dependency.name}"
                                     end

              hook_file_path = "#{dependency_directory}/githooks/#{key}"

              file.write("# #{dependency.name} githook\n")
              file.write("if [ -f \"#{hook_file_path}\" ]; then\n")
              file.write("  function #{dependency.name}(){\n")
              file.write("    local script_directory=#{dependency_directory}/scripts\n")
              File.readlines(hook_file_path).each { |line|
                file.write("    #{line}")
              }
              file.write("\n  }\n")
              file.write("  #{dependency.name}\n")
              file.write("fi\n")
            end

            FileUtils.chmod('+x', file_path)
          end
        }
      end

      def sync
        Pod::UI.message 'Start syncing Git Hook' do
          return unless validate_git_directory?

          FileUtils.mkdir '.git/hooks' unless File.directory?('.git/hooks')

          abstract_target = abstract_target_of_githooks
          return if abstract_target.nil?
          dependencies = dependencies_in_target(abstract_target)
          if dependencies.nil? || dependencies.empty?
            Pod::UI.warn 'The dependencies of SyncGithooks is nil or empty.'
            return
          end
          dependencies.each { |dependency|
            Pod::UI.message "- #{dependency.name}"
          }
          sync_githooks_in_dependencies(dependencies)
        end
        Pod::UI.message 'Githooks are synced'
      end
    end
  end
end