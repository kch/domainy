#!/usr/bin/env ruby
# encoding: UTF-8
require File.join(File.dirname(__FILE__), 'vendor/dominion/lib/dominion')
require 'sinatra'
require 'kramdown'

TEN_YEARS = 60 * 60 * 24 * 30 * 12 * 10 # Overkill
RX_IPV4   = /\A\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}\z/


def extract_base_domain(s)
  s =~ RX_IPV4 ? s : Dominion::DomainName.new(s).base
end

get "/" do
  content_type "text/html; charset=utf-8"
  Kramdown::Document.new(IO::read(File.join(File.dirname(__FILE__), "README.markdown"))).to_html
end

## API Method
get "/*" do
  content_type "text/plain; charset=utf-8"
  response["Cache-Control"] = "public, max-age=#{TEN_YEARS}"
  params[:splat][0].split("/").map { |s| extract_base_domain(s) }.join(",")
end
