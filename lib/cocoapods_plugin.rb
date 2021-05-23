require 'cocoapods-sync-githooks/command'
require 'cocoapods-sync-githooks/sync_githooks'

module CocoapodsGitHooks
  Pod::HooksManager.register('cocoapods-sync-githooks', :post_install) do |context|
    CocoapodsGitHooks::GitHooksManager.sync
  end
  Pod::HooksManager.register('cocoapods-sync-githooks', :post_update) do |context|
    CocoapodsGitHooks::GitHooksManager.sync
  end
end