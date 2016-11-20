require 'pp'
require 'json'

file_path = 'expanded'
begin_data = false
mushrooms_data = []
mushroom_attrs = [
  'edible',
  'cap-shape',
  'cap-surface',
  'cap-color',
  'bruises?',
  'odor',
  'gill-attachment',
  'gill-spacing',
  'gill-size',
  'gill-color',
  'stalk-shape',
  'stalk-root',
  'stalk-surface-above-ring',
  'stalk-surface-below-ring',
  'stalk-color-above-ring',
  'stalk-color-below-ring',
  'veil-type',
  'veil-color',
  'ring-number',
  'ring-type',
  'spore-print-color',
  'population',
  'habitat'
]

File.readlines(file_path).each_with_index do |line, index|
  mushroom = {}
  line = line.gsub(/\n/, '')
  break if begin_data && line.match(/-{70}/)

  if !begin_data && line.match(/-{70}/)
    begin_data = true
    next
  end

  next unless begin_data

  mushroom_values = line.split(',')
  mushroom_values.each_with_index do |value, i|
    mushroom[mushroom_attrs[i]] = value
  end

  mushrooms_data.push(mushroom)
end

File.open("expanded.json","w") do |f|
  f.write(JSON.generate(mushrooms_data))
end
