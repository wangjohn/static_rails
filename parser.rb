class Parse

  # regexes for the erb insertion
  PARAMETER_REGEXES = {
    :no_line_break => /-\%\>/,
    :equals => /\<\%=/
  }

  def initialize(htmlfile, data_string=nil)
    @@binding_wrapper = BindingWrapper.new
    @@text = File.new(htmlfile, 'r').read
    inject_data(data_string) if data_string
  end

  def scan_for_ruby
    results = []
    scan_results = @@text.scan(/(\<\%=?)(.*?)(-?\%\>)/m)
    scan_results.each do |result|
      parameters = check_regex_results(result)
      if parameters[:equals]
        # if there is an equal sign, then we must output the result
        substitution_string = eval(result[1], @@binding_wrapper.get_binding).to_s
        if !parameters[:no_line_break]
          # put in a line break only when we output results, and only when there's supposed to be a line break
          substitution_string += "\n"
        end
        results << substitution_string
      else
        # otherwise, we only evaluate the result
        eval(result[0], @@binding_wrapper.get_binding) 
      end
    end
    results
  end

  def perform_code
    results = scan_for_ruby
    new_text = @@text
    counter = 0
    while new_text =~ /\<\%=(.*?)-?\%\>/m
    	new_text = new_text.sub(/\<\%=(.*?)-?\%\>/m, results[counter])
        counter += 1
    end
    return new_text
  end

  def inject_data(data_string)
    eval(data_string, @@binding_wrapper.get_binding)
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

