class DPDARulebook < Struct.new(:rules)
  def next_configuration(configuration, charactor)
    rules_for(configuration, charactor)&.follow(configuration)
  end

  def rules_for(configuration, charactor)
    rules.detect { |rule| rule.applies_to?(configuration, charactor) }
  end
end
