class FlagService
  class InvalidReport < StandardError; end

  def self.process(flagger, survivor)
    raise InvalidReport.new('Survivor is already marked as infected') if survivor.infected? or flagger.infected?
    raise InvalidReport.new('Survivor was already reported by this survivor') if flagger.survivors.include? survivor

    if survivor.infection_count.eql? 2
      survivor.infected = true
      survivor.save!
    else
      survivor.increment!(:infection_count)
      flagger.survivors.append(survivor)
    end
  end
end
