require 'parser'

FILES_TO_CONVERT = {
  'test_html.html.erb' => 'test_html.html'
}

DATA_FILES = [
  'test_data.rb'
]

def merged_data_files
  output = ''
  for filename in DATA_FILES
    output += File.open(filename, 'r').read
  end
  output
end

FILES_TO_CONVERT.each do |input_file, output_file|
  parser = Parse.new(input_file, merged_data_files)
  File.open(output_file, 'w'){|f| f.write(parser.perform_code)}
end
