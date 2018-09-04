# -*- encoding: utf-8 -*-
require "csv"
require "yaml"
require "json"
require 'excel2csv'

@config ={
  "greatmans_code" => YAML.load_file("config/greatmans_code.yml")
}

def convert_text(text)
  return nil if text.nil?
  str = text.gsub("\n","\r\n")
  str.gsub(/\\(.+?)\\n/, '__\1__')
end

def contents_to_result_contents(filename, sheetIndex)
  result_contents = {}

  Excel2CSV.foreach(filename, sheet:sheetIndex) do |row|
    if row[0] != nil
      result = {}
      index = 1
      @config["greatmans_code"].each_with_object([]) do |(key ,val)|
        result[val] = convert_text(row[index])
        index += 1
      end

      result_contents[@config["greatmans_code"][row[0]]] = result

    end
  end
  return [result_contents]
end



input_dir = "inputs/"
output_dir = "outputs/"
# output_dir = "./"
if ARGV.size > 0
  input_dir = ARGV[0]
end
if ARGV.size > 1
  output_dir = ARGV[1]
end

print "Start\n"
fileName = "compatibility_diagnosis"
path = input_dir + fileName + ".xlsx"

startSheetIndex = 0
endSheetIndex = 0
for i in startSheetIndex..endSheetIndex do
  out_puts = contents_to_result_contents(path,i)

  puts out_puts
  # out_puts = initialized_contents_to_out_puts(initialized_contents, fileName)

  output_path = output_dir ? output_dir : "outputs/"

  File.open(output_path + fileName + '.json','w'){|f|
   f.write JSON.pretty_generate(out_puts)
   f.close
  }

  puts "Output => #{output_path + fileName}.json"
  end


print "End\n"
