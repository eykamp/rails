require 'abstract_unit'
require 'rails/test_unit/sub_test_task'

module Rails
  class TestInfoTest < ActiveSupport::TestCase
    def test_test_files
      info = new_test_info ['test']
      assert_predicate info.files, :empty?
      assert_nil info.opts
      assert_equal ['test'], info.tasks
    end

    def test_with_file
      info = new_test_info ['test', __FILE__]
      assert_equal [__FILE__], info.files
      assert_nil info.opts
      assert_equal ['test'], info.tasks
    end

    def test_with_opts
      info = new_test_info ['test', __FILE__, '/foo/']
      assert_equal [__FILE__], info.files
      assert_equal '-n /foo/', info.opts
      assert_equal ['test'], info.tasks
    end

    def new_test_info(tasks)
      Class.new(TestTask::TestInfo) {
        def task_defined?(task)
          task == "test"
        end
      }.new tasks
    end
  end
end
