require 'pp'
require 'json'

file = File.read('expanded.json')
tranning_set = JSON.parse(file)
mushroom_attrs = [
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

def group_entropy(tranning_set)
  poisonous_count = tranning_set.count{|feature| feature['edible'] == 'POISONOUS' }.to_f
  edible_count = tranning_set.count{|feature| feature['edible'] == 'EDIBLE' }.to_f
  tranning_set_count = tranning_set.count.to_f

  poisonous_percent = poisonous_count/tranning_set_count
  edible_percent = edible_count/tranning_set_count

  $group_entropy ||= -1 * (poisonous_percent * Math.log2(poisonous_percent) + edible_percent * Math.log2(edible_percent))
end

def calc_attr_gi(tranning_set, attribute)
  attribute_values = []
  tranning_set_count = tranning_set.count.to_f
  tranning_set.each do |feature|
    value = feature[attribute]
    attribute_values.push(value) unless attribute_values.find_index(value)
  end

  pp "#{attribute}:"

  sum = 0
  attribute_values.each do |value|
    value_group = tranning_set.select{|feature| feature[attribute] == value}
    group_count = value_group.count.to_f
    poisonous_count = value_group.count{|feature| feature['edible'] == 'POISONOUS' }.to_f
    edible_count = value_group.count{|feature| feature['edible'] == 'EDIBLE' }.to_f

    poisonous_percent = poisonous_count/group_count
    edible_percent = edible_count/group_count
    group_percent = group_count/tranning_set_count

    entropy = -1 * (poisonous_percent * Math.log2(poisonous_percent) + edible_percent * Math.log2(edible_percent))

    sum += group_percent * entropy unless entropy.nan?
    pp " > In #{value}: "
    pp "   - Correlation: #{calc_correlation(poisonous_count, edible_count)}"
    pp "   - Edible: #{(edible_percent*100).round(1)}% "
    pp "   - Poisonous: #{(poisonous_percent*100).round(1)}% "
  end

  gi = group_entropy(tranning_set) - sum

  pp " > Information Gain #{gi.round(2)}"
end

def calc_correlation(n, m)
  ((n+1).to_f/(n+m+2).to_f).round(5)
end

pp "Group Entropy: #{group_entropy(tranning_set)}"
mushroom_attrs.each do |attr|
   calc_attr_gi(tranning_set, attr)
end