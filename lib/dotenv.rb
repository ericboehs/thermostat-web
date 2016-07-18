%w[.env .env.local].each do |file|
  File.readlines(file).each do |line|
    next if line.start_with? "#"
    key, value = line.split "=", 2
    value = value.chomp
    value = value[0..-1] if ['\'', '"'].include? value.chars.first
    value = value[1...-1] if ['\'', '"'].include? value.chars.last
    value = value.gsub '\n', "\n"
    ENV[key] ||= value
  end if File.exists? file
end
