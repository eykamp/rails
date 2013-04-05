require 'rake/testtask'

module Rails
  class TestTask < Rake::TestTask # :nodoc: all
    class TestInfo
      def initialize(tasks)
        @tasks = tasks
      end

      def files
        @tasks.find_all { |t| File.file?(t) && !File.directory?(t) }
      end

      def tasks
        @tasks - files - opt_names
      end

      def opts
        opts = opt_names
        if opts.any?
          "-n #{opts.join ' '}"
        end
      end

      private

      def opt_names
        (@tasks - files).reject { |t| task_defined? t }
      end

      def task_defined?(task)
        Rake::Task.task_defined? task
      end
    end

    def self.test_info(tasks)
      TestInfo.new tasks
    end

    def initialize(name = :test)
      super
      @libs << "test" # lib *and* test seem like a better default
    end

    def define
      task @name do
        if ENV['TESTOPTS']
          ARGV.replace Shellwords.split ENV['TESTOPTS']
        end
        libs = @libs - $LOAD_PATH
        $LOAD_PATH.unshift(*libs)
        file_list.each { |fl|
          FileList[fl].to_a.each { |f| require File.expand_path f }
        }
      end
    end
  end

  # Silence the default description to cut down on `rake -T` noise.
  class SubTestTask < Rake::TestTask # :nodoc:
    def desc(string)
      # Ignore the description.
    end
  end
end
