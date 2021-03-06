require 'rspec/autorun'
require 'ripper'

def test_file_path(file_name)
  File.join(
    File.dirname(__FILE__),
    "test_classes/#{file_name}.rb"
  )
end

def read_test_file(file_name)
  File.read(
    test_file_path(file_name)
  )
end

def load_args_block(method_call)
  loader = ArgsLoader.new
  loader.load(method_call)
end

class ArgsLoader
  def reset!
    @sexp = nil
  end

  def load(method_call)
    reset!
    load_method_add_arg(Ripper.sexp(method_call))
    return @sexp
  end

  private
  def load_method_add_arg(method_sexp)
    method_sexp.each do |s|
      next unless s.kind_of?(Array)

      s.each do |a|
        next unless a.kind_of?(Array)

        if a.first == :args_add_block
          @sexp ||= a
        else
          load_method_add_arg(s)
        end
      end
    end
  end
end
