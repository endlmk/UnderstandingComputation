class DPDARulebook < Struct.new(:rules)
  def next_configuration(configuration, character)
    rules_for(configuration, character)&.follow(configuration)
  end

  def rules_for(configuration, character)
    rules.detect { |rule| rule.applies_to?(configuration, character) }
  end

  def applies_to?(configuration, character)
    !rules_for(configuration, character).nil?
  end

  def follow_free_moves(configuration)
    if applies_to?(configuration, nil)
      follow_free_moves(next_configuration(configuration, nil))
    else
      configuration
    end
  end
end
