class FlagService
  class InvalidReport < StandardError; end

  def self.process(flagger, survivor)
    raise InvalidReport.new(I18n.t('errors.services.flag.infected'))  if survivor.infected?
    raise InvalidReport.new(I18n.t('errors.services.flag.recurrent')) if flagger.survivors.include? survivor
    raise InvalidReport.new(I18n.t('errors.services.flag.infected_flagger')) if flagger.infected?
    if survivor.infection_count.eql? 2
      survivor.infected = true
      survivor.save!
    else
      survivor.increment!(:infection_count)
      flagger.survivors.append(survivor)
    end
  end
end
