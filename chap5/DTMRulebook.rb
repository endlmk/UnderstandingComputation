require_relative('TMRule')

class DTMRulebook < Struct.new(:rules)
  def next_configuration(configuration)
    rule_for(configuration).follow(configuration)
  end

  def rule_for(configuration)
    rules.detect { |r| r.applies_to?(configuration) }
  end

  def applies_to?(configuration)
    !rule_for(configuration).nil?
  end
end
