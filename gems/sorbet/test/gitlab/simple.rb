# frozen_string_literal: true
# typed: ignore

require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/minitest'

require 'tmpdir'

class Sorbet; end
module Sorbet::Private; end
module Sorbet::Private::Gitlab; end
module Sorbet::Private::Gitlab::Test; end

def with_clean_rbenv
  old_path = ENV["PATH"]
  ENV["PATH"] = ENV["PATH"].split(":").reject { |p| p.index("#{ENV["RBENV_ROOT"]}/versions/") == 0 }.join(":")
  begin
    ENV["RBENV_VERSION"] = "2.5.3"
    yield
  ensure
    ENV["PATH"] = old_path
  end
end

class Sorbet::Private::Gitlab::Test::Simple < MiniTest::Spec
  it 'works on gitlab' do

    Dir.mktmpdir do |dir|
      FileUtils.cp_r(__dir__ + '/gitlab/', dir)
      FileUtils.cp_r(__dir__ + '/sorbet/', dir)
      olddir = __dir__
      Dir.chdir(dir + '/gitlab/')

      with_clean_rbenv do
        # IO.popen(olddir + '/../../bin/srb-rbi') do
        # end
        system('echo "N" | rbenv install 2.5.3')
        # ENV['PATH'] = "#{ENV['RBENV_ROOT']}/versions/2.5.3/bin:#{ENV['PATH']}"
        system('rbenv version')
        system('echo $PATH')
        system('which ruby')
        system('rbenv exec gem install bundler')
        system('BUNDLE_GEMFILE=./Gemfile rbenv exec bundle install')
        system('rbenv exec ruby -v')
        system('printf "gem \'sorbet\'" >> Gemfile')
        # system('gem install ' + olddir + '/../../../gems/sorbet-static/sorbet-static-0.0.0.gem')
        ENV['SRB_YES'] = '1'
        system('echo "y" | rbenv exec bundle exec ' + olddir + '/../../bin/srb-rbi')
        system('srb tc')
      end

      assert_equal(true, $?.success?)
      # Some day these can be snapshot tests, but this isn't stable enough for
      # that yet
      # assert_equal(File.read(olddir + '/simple.errors.txt'), File.read('rbi/hidden-definitions/errors.txt'))
      # assert_equal(File.read(olddir + '/simple.hidden.rbi'), File.read('rbi/hidden-definitions/hidden.rbi'))
      # assert_match("class Foo\n  def bar()", File.read('sorbet/rbi/hidden-definitions/hidden.rbi'))
    end
  end
end
