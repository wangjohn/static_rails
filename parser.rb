class Parse
  def initialize(text)
    @@text = text
    @@sheet_data = {}
    @@results = []
  end

  def scan_for_ruby
    scan_results = @@test.scan(/\<\%(=?)(.*?)-?\%\>/m)
    scan_results.each do |result|
      if result.length == 2
        # check if there is an equal sign and print the output
        if result[0] =~ /=/
          @@results = eval(result[1])
        end
      else
        eval(result[0]) 
      end
    end
  end

  def perform_code

  end
end

class BindingWrapper
  def initialize
  end 
  def get_binding
    return binding
  end
end

class CodeEvaluation
  def initialize(code)
    @code = code
    @binding = BindingWrapper.new
    @variables_hash = {}
  end

  def evaluate
    eval(@code, @binding.get_binding)
    @variables = @binding.eval('local_variables')
    puts @variables
  end

  def get_locals
    @variables_hash
  end
end

ce = CodeEvaluation.new("a = 5")
ce.evaluate
ce.get_locals
