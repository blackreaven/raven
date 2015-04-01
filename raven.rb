require 'rubygems'
require 'commander'
require 'thread'

require_relative 'modules/fuzzer/fuzzer'
require_relative 'modules/generator/generator'

class RavenApplication
  include Commander::Methods

  def run
    program :name, 'Raven'
    program :version, '0.0.1'
    program :description, 'Hacking tool repository.'

    command :generator do |c|
      c.syntax = 'raven generator'
      c.description = 'Generate word list'
      c.option '-m', '--min SIZE', Integer, 'Set min size'
      c.option '-M', '--max SIZE', Integer, 'Set max size'
      c.option '-c', '--charset CHARSET', String, 'Set max size'
      c.option '-o', '--out FILENAME', String, 'Set output file'
      c.option '-r', '--random', 'Generate only one random password'
      c.option '-t', '--thread', 'use multithreading'
      c.action do |args, options|
        options.default \
          :min => 1,
          :max => 2,
          :charset => [('a'..'z'), ('A'..'Z'), ('!'..'?')].map { |i| i.to_a }.flatten

        if options.charset.kind_of?(String)
          options.charset = options.charset.split('')
        end

        generator = Raven::Generator.new(options.min, options.max, options.charset)

        if options.thread
          generator.thread(options.thread)
        else
          generator.generate()
        end

        p generator.results
      end
      run!
    end
  end
end


RavenApplication.new.run if $0 == __FILE__