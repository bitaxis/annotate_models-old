namespace :annotate do
  
  desc "Annotate everything"
  task :all => [:factories, :models, "test:unit"]
  
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
  
  namespace :test do

    desc "Annotate unit tests"
    task :unit => :environment do
      am = ModelAnnotationGenerator.new
      am.generate
      am.apply_to_unit_tests
    end

  end
  
end
