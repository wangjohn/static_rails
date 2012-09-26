require 'parser'

RELATIVE_PATH = '/'
FILES_TO_CONVERT = {
  'test_html.html.erb' => 'test_html.html'
}
DATA_FILES = [
  'test_data.rb'
]

def merged_data_files
  output = ''
  for filename in DATA_FILES
    output += File.open(RELATIVE_PATH + filename, 'r').read
  end
  output
end

FILES_TO_CONVERT.each do |input_file, output_file|
  parser = Parse.new(RELATIVE_PATH + input_file, merged_data_files)
  File.open(RELATIVE_PATH + output_file, 'w'){|f| f.write(parser.perform_code)}
end
