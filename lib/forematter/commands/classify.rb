# encoding: utf-8

value_args  :none
aliases     :categorize
summary     'classify files by the given field'
description <<-EOS
Classify a set of files by the given frontmatter field.

For example, automatic classification could be used to select categories for
articles or blog posts:

    fore classify category articles/*.md

By default, files which already have a value for the given field are used to
train the classifier, and files without a value are automatically classified.

If the `--override` option is passed, the classifier will be trained on the
available files as usual, and every file will be re-classified.

If the given frontmatter field is present on a file, but the value isn't a
string, `fore classify` will exit with an error.
EOS

flag nil, :override, 'Override existing values'

module Forematter::Commands
  class Classify < Forematter::CommandRunner
    def run
      load_classifier
      add_categories
      train_classifier
      classify_files
    end

    protected

    def load_classifier
      require 'classifier'
    rescue LoadError
      $stderr.puts 'Install "classifier" gem to generate suggestions'
      exit 1
    end

    def add_categories
      puts 'Finding categories'
      categories_for(files_with(field)).each { |cat| bayes.add_category(cat) }

      if bayes.categories.empty?
        $stderr.puts "No categories found in #{field}, unable to classify"
        exit 1
      else
        found = bayes.categories.length
        puts "#{found} #{found == 1 ? 'category' : 'categories'} found"
      end
    end

    def train_classifier
      puts 'Training classifier'
      files_with(field).each { |file| train(file) }
    end

    def classify_files
      puts 'Classifying files'
      files_to_classify.each { |file| file.write if classify(file) }
    end

    def bayes
      @bayes ||= Classifier::Bayes.new
    end

    def categories_for(files)
      files
        .map { |file| file[field].to_ruby }
        .select { |f| f.is_a?(String) }
        .uniq
        .map(&:to_sym)
    end

    def files_to_classify
      files.reject do |file|
        file.key?(field) unless options[:override]
      end
    end

    def train(file)
      val = file[field].to_ruby
      unless val.is_a?(String)
        skip file, "unable to train, #{field} is not a string"
        return
      end
      bayes.train(val.to_sym, file.content)
    end

    def classify(file)
      old = file[field].to_ruby
      file[field] = bayes.classify(file.content).to_s
      file[field].to_ruby != old
    end
  end
end

runner Forematter::Commands::Classify
