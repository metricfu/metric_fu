begin
  require "code_notes"
  @annotator = CodeNotes::SourceAnnotationExtractor
rescue LoadError
  require 'rails/source_annotation_extractor'
  @annotator = SourceAnnotationExtractor
rescue LoadError
  # no notes
end
if @annotator
  Rake::Task[:notes].clear if Rake::Task.task_defined?(:notes)
  desc "Enumerate all annotations (use notes:optimize, :fixme, :todo for focus)"
  task :notes do
    @annotator.enumerate "OPTIMIZE|FIXME|TODO|TECHDEBT|HACK", tag: true
  end

  namespace :notes do
    ["OPTIMIZE", "FIXME", "TODO", "TECHDEBT", "HACK"].each do |annotation|
      desc "Enumerate all #{annotation} annotations"
      task annotation.downcase.intern do
        @annotator.enumerate annotation
      end
    end

    desc "Enumerate a custom annotation, specify with ANNOTATION=CUSTOM|ANOTHER"
    task :custom do
      @annotator.enumerate ENV["ANNOTATION"]
    end
  end
end

