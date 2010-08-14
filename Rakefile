# -*- ruby -*-

$LOAD_PATH << './lib'
require 'jekyll-svg-plugin/base'

require 'rubygems'
gem     'rjack-tarpit', '~> 1.2.2'
require 'rjack-tarpit'

t = RJack::TarPit.new( 'jekyll-svg-plugin', JekyllSVGPlugin::VERSION )

t.specify do |h|
  h.developer( 'David Kellum', 'dek-oss@gravitext.com' )
  h.extra_deps << [ 'imagesize', '>= 0.1.1' ]
end

task :check_history_version do
  t.test_line_match( 'History.rdoc', /^==/, / #{ t.version } / )
end
task :check_history_date do
  t.test_line_match( 'History.rdoc', /^==/, /\([0-9\-]+\)$/ )
end

task :gem  => [ :check_history_version, ]
task :tag  => [ :check_history_version, :check_history_date ]
task :push => [ :check_history_version, :check_history_date ]

task :test #noop

t.define_tasks
