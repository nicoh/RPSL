require 'rgen/metamodel_builder'
require_relative '../rpsl_conceptual_space'

module RpslExecutionMetaModel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes


   class ExecutionUnit < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class Process < ExecutionUnit
   end

   class Thread < ExecutionUnit
   end

end

RpslExecutionMetaModel::Process.contains_many_uni 'thread', RpslExecutionMetaModel::Thread 
RpslExecutionMetaModel::Process.has_many 'process_property_prototype', RpslConceptualSpaceMetaModel::Prototype
RpslExecutionMetaModel::Thread.has_many 'thread_property_prototype', RpslConceptualSpaceMetaModel::Prototype 
