class ModelAnnotationGenerator
  
  def initialize
    @annotations = {}
  end
  
  def apply_to_factories
    pn_factories = Pathname.new("test/factories")
    return unless pn_factories.exist?
    @annotations.each do |model, annotation|
      pn = pn_factories + "#{ActiveSupport::Inflector.underscore(model.name)}_factory.rb"
      text = File.open(pn.to_path) { |fp| fp.read }
      re = Regexp.new("^# (?:=-)+=\n# #{model.name}.*\n(?:#.+\n)+# (?:=-)+=\n", Regexp::MULTILINE)
      if re =~ text
        text = text.sub(re, annotation)
      else
        text = annotation + "\n" + text
      end
      File.open(pn.to_path, "w") { |fp| fp.write(text) }
      puts "Annotated #{pn.to_path}."
    end
  end
  
  def apply_to_models
    pn_models = Pathname.new("app/models")
    return unless pn_models.exist?
    @annotations.each do |model, annotation|
      pn = pn_models + "#{ActiveSupport::Inflector.underscore(model.name)}.rb"
      text = File.open(pn.to_path) { |fp| fp.read }
      re = Regexp.new("^# (?:=-)+=\n# #{model.name}.*\n(?:#.+\n)+# (?:=-)+=\n", Regexp::MULTILINE)
      if re =~ text
        text = text.sub(re, annotation)
      else
        text = annotation + "\n" + text
      end
      File.open(pn.to_path, "w") { |fp| fp.write(text) }
      puts "Annotated #{pn.to_path}."
    end
  end
  
  def generate
    Dir["app/models/*.rb"].each do |path|
      result = File.basename(path).scan(/^(.+)\.rb/)[0][0]
      model = eval(ActiveSupport::Inflector.camelize(result))
      next unless model < ActiveRecord::Base
      @annotations[model] = generate_annotation(model) unless @annotations.keys.include?(model)
    end
  end
  
  def print
    @annotations.values.sort.each do |annotation|
      puts annotation
      puts
    end
  end
  
  private
    
  def generate_annotation(model)
    annotation = []
    annotation << "# #{'=-' * 38}="
    annotation << "# #{model.name}"
    annotation << "#"
    annotation << "# Name                           SQL Type             Null    Default Primary"
    annotation << "# ------------------------------ -------------------- ------- ------- -------"
    model.columns.each do |column|
      annotation << sprintf("# %-30s %-20s %-7s %-7s %-7s", column.name, column.sql_type, column.null, (column.default || ""), (column.primary || ""))
    end
    annotation << "#"
    annotation << "# #{'=-' * 38}="
    annotation.join("\n") + "\n"
  end
  
end
