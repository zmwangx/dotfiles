# -*- mode: ruby -*-
#
# brew-cask external command that prints the staged path of a cask, or prints
# nothing and exits with 1 if the cask is not installed.

command_name = ARGV.shift
cask_token = ARGV.shift

cask = Hbc.load(cask_token)

if cask.installed?
  puts cask.staged_path
else
  exit 1
end
