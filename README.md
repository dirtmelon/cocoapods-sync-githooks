# cocoapods-sync-githooks

cocoapods-sync-githooks is a CocoaPods plugin to sync git hooks. Manage shared githooks scripts through the Pod library, even in different repositories.

## Installation

Install with `gem install`

```shell
$ gem install cocoapods-sync-githooks
```

or add `cocoapods-sync-githooks` to the `Gemfile`:

```ruby
gem 'cocoapods-sync-githooks'
```

## Usage

1. Add `cocoapods-sync-githooks` to your `Podfile`:

```ruby
platform :ios, '9.0'

plugin 'cocoapods-sync-githooks'

target 'SyncGithooksDemo' do
end
```

2. Add pods of git hooks under `Githooks` abstract_target.
```ruby
abstract_target 'Githooks' do
  pod 'githooksA', git: 'https://github.com/dirtmelon/githooksA.git'
  pod 'githooksB', git: 'https://github.com/dirtmelon/githooksB.git'
end
```

3. Edit scripts of git hooks in different pods. The git hooks script needs to be placed in the `githooks` directory. You can also put the script in the `scripts` directory, then call in the script of git hooks .

```shell
// pre-commit, much use ${script_directory} to get correct directory.
ruby ${script_directory}/Test.rb
```

[SyncGithooksDemo](https://github.com/dirtmelon/SyncGithooksDemo)

[GithooksA](https://github.com/dirtmelon/githooksA.git)

[GithooksB](https://github.com/dirtmelon/githooksB.git)
