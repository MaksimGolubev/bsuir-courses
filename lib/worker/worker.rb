require 'colorize'
require 'yaml'

$LOAD_PATH.unshift(File.dirname(File.realpath(__FILE__)))

module Gardener
  class Worker
    SEPARATOR = '======='.red
    FILE_LIST = (Dir.entries("#{$LOAD_PATH.first}/trees") - %w[. ..]).map { |tree| tree.sub('.tree', '')}.freeze

    def initialize(params)
      @tree_name = find_name(params)
    end

    def work
      if @tree_name.nil?
        FILE_LIST.each do |tree|
          puts "#{tree}.tree"
          tree = plant_tree(tree)
          puts tree.to_s
          work_with_tree_result(tree)
          print 'Желаете продолжить?[Y/n] '
          return if gets.chomp == 'n'
        end
      elsif FILE_LIST.include?(@tree_name)
        plant_tree(@tree_name)
        puts SEPARATOR, @tree_name, SEPARATOR, FILE_LIST
      else
        return puts 'Данное дерево не растет в данном лесу.'
      end
    end
    private

    def work_with_tree_result(tree)
      return puts 'Срубить.' if tree.flatten.sum > 100
      return puts 'Обрезать.' if tree.to_s.scan(/\[\d*\, \[/).size > 5
    end

    def plant_tree(tree_name)
      # tree = open_tree(tree_name)
      tree = [1 ,[[2 ,[3 , 4 ]],[3,[5,2]]]]
      # TODO draw picture tree
      # require 'pry'; binding.pry
      tree
    end

    def open_tree(tree_name)
      file_path = "#{$LOAD_PATH.first}/trees/#{tree_name}.tree"
      tree = File.open(file_path) { |file|file.read.chomp }
      eval tree
    end

    def find_name(params)
      params.each { |arg| return arg.match(/NAME=(\w*)/)[1] if arg.match(/NAME=(\w*)/) }
      nil
    end
  end
end
