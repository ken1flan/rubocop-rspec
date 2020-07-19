# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

local_gemfile = 'Gemfile.local'

gem 'rubocop', github: 'bquorning/rubocop', ref: '4c3e21c82bc0f29a87d396bb1ea11'

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile)) # rubocop:disable Security/Eval
end
