class Parse
  def initialize(text)
    @text = text
    @sheet_data = {}
    @results = []
  end

  def scan_for_ruby
    scan_results = @test.scan(/\<\%(=?)(.*?)-?\%\>/m)
    scan_results.each do |result|
      if result.length == 2
        # check if there is an equal sign and print the output
        if result[0] =~ /=/
          @results = eval(result[1])
        end
      else
 
      end
    end
  end

  def perform_code

  end
end
