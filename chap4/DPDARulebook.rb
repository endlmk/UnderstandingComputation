class DPDARulebook < Struct.new(:rules)
  def next_configuration(configuration, charactor)
    rules.detect { |rule| rule.applies_to?(configuration, charactor) }&.follow(configuration)
  end
end
