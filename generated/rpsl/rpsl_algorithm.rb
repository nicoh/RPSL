require 'rgen/metamodel_builder'
require_relative 'rpsl_conceptual_space'

module RpslAlgorithmMetaModel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes

   COMPLEXITY = Enum.new(:name => 'COMPLEXITY', :literals =>[ :CONSTANT, :LINEAR, :DOUBLE_LOG, :EXPONENTIAL, :ANYTIME ])

   class Category < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class Algorithm < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
      has_attr 'complexity', RpslAlgorithmMetaModel::COMPLEXITY 
   end

   class AlgorithmImplementation < Algorithm
   end

end

RpslAlgorithmMetaModel::Category.contains_many_uni 'sub_category', RpslAlgorithmMetaModel::Category 
RpslAlgorithmMetaModel::Algorithm.has_one 'category', RpslAlgorithmMetaModel::Category, :lowerBound => 1 
RpslAlgorithmMetaModel::AlgorithmImplementation.has_many 'algorithm_property_prototype', RpslConceptualSpaceMetaModel::Prototype
