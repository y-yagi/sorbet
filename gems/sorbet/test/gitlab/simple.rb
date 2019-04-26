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

class Sorbet::Private::Gitlab::Test::Simple < MiniTest::Spec
  it 'works on gitlab' do

    Dir.mktmpdir do |dir|
      FileUtils.cp_r(__dir__ + '/gitlab/', dir)
      olddir = __dir__
      Dir.chdir(dir + '/gitlab/')

      with_clean_rbenv do
        system('rbenv exec ruby -S gem install bundler')
        system("BUNDLE_GEMFILE=./Gemfile rbenv exec ruby -S bundle install") # TODO: this line fails
        system("rbenv exec ruby -S gem install rails")
        system('printf "gem \'sorbet\'" >> Gemfile')
        ENV['SRB_YES'] = '1'
        system("echo 'y' | rbenv exec bundle exec " + olddir + "/../../bin/srb-rbi")
        system('srb tc')
      end

      assert_equal(true, $?.success?)
    end
  end
end
