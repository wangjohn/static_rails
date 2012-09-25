class Parse

  # regexes for the erb insertion
  PARAMETER_REGEXES = {
    :no_line_break => /-\%\>/,
    :equals => /\<\%=/
  }

  def initialize(htmlfile, datafile)
    @@binding_wrapper = BindingWrapper.new
    @@text = File.new(htmlfile, 'r').read
    inject_data(datafile)
  end

  def scan_for_ruby
    results = []
    scan_results = @@text.scan(/(\<\%=?)(.*?)(-?\%\>)/m)
    scan_results.each do |result|
      parameters = check_regex_results(result)
      substitution_string = ""
      if parameters[:equals]
        # if there is an equal sign, then we must output the result
        substitution_string = eval(result[1], @@binding_wrapper.get_binding).to_s
      else
        # otherwise, we only evaluate the result
        eval(result[0], @@binding_wrapper.get_binding) 
      end
      if parameters[:equals] && !parameters[:no_line_break]
        # put in a line break only when we output results, and only when there's supposed to be a line break
        substitution_string += "\n"
      end
    end
    results
  end

  def perform_code
    results = scan_for_ruby
    new_text = @@text
    counter = 0
    while new_text =~ /\<\%=(.*?)-?\%\>/m
    	new_text = new_text.gsub(/\<\%=(.*?)-?\%\>/m, results[counter])
        counter += 1
    end
    return new_text
  end

  def inject_data(datafile)
    file = File.new(datafile, 'r').read
    eval(file, @@binding_wrapper.get_binding)
  end

  private 
  def check_regex_results(result)
    parameters = {}
    result.each do |match|
      PARAMETER_REGEXES.each do |key, value|
        parameters[key] = true if match =~ value
      end
    end
    parameters
  end
end

class BindingWrapper
  def initialize
  end 
  def get_binding
    return binding
  end
end


parsed = Parse.new('test_html.html.erb', 'test_data.rb')
puts parsed.perform_code
