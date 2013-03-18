require "pullentity-client/version"

require 'rubygems'
require 'pathname'
require 'fileutils'
require 'rbconfig'
require 'colored'
require 'rocco'
require 'thor'
require 'erubis'
require 'nokogiri'
require 'json'

module Pullentity
  module Client
    ROOT_PATH = Pathname(__FILE__).dirname.expand_path

    autoload  :VERSION,       'pullentity-client/version.rb'
    autoload  :CLI,           'pullentity-client/cli.rb'
    autoload  :Logger,        "pullentity-client/logger.rb"
    autoload  :Utils,         "pullentity-client/utils.rb"

    module Generate
      autoload  :Project,     "pullentity-client/generate/project.rb"
      autoload  :Model,       "pullentity-client/generate/model.rb"
      autoload  :Exporter,    "pullentity-client/generate/exporter.rb"
    end

    module Builder
      autoload :Middleman,     'pullentity-client/builder/middleman.rb'
    end

    def self.root
      @root ||= Pathname(__FILE__).dirname.expand_path
    end
  end
end
