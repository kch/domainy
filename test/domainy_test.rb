#!/usr/bin/env ruby
# encoding: UTF-8
require File.dirname(__FILE__) + "/../domainy"
require 'contest'
require 'rack/test'

class DomainyTest < Test::Unit::TestCase
  include Rack::Test::Methods
  def app; Sinatra::Application; end

  def self.test_domain(expected, from)
    test "#{from} ~ #{expected}" do
      get "/#{from}"
      assert last_response.ok?
      assert_equal expected, last_response.body
    end
  end

  describe "Domainy" do
    test_domain "example.com"                , "example.com"
    test_domain "127.0.0.1"                  , "127.0.0.1"
    test_domain "example.com.pk"             , "example.com.pk"
    test_domain "tv.com"                     , "example.tv.com"
    test_domain "com.tv"                     , "example.com.tv"
    test_domain "website.co.uk"              , "secure.email.website.co.uk"
    test_domain  "thisIsMyMainWebsite.gov.cl", "this.is.a.worst.shortly.subdomain.thisIsMyMainWebsite.gov.cl"

    test "handles multiple domains" do
      get "/foo.com/bar.foo.co.uk"
      assert_equal "foo.com,foo.co.uk", last_response.body
    end
  end

end
