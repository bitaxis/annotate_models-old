namespace :annotate do
  
  desc "Annotate everything"
  task :all => [:factories, :models]
  
  desc "Annotate factories"
  task :factories => :environment do
    am = ModelAnnotationGenerator.new
    am.generate
    am.apply_to_factories
  end

  desc "Annotate ActiveRecord models"
  task :models => :environment do
    am = ModelAnnotationGenerator.new
    am.generate
    am.apply_to_models
  end
  
  desc "Print annotations"
  task :print => :environment do
    am = ModelAnnotationGenerator.new
    am.generate
    am.print
  end
  
end
