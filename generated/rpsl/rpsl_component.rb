require 'rgen/metamodel_builder'
require_relative 'rpsl_conceptual_space'
require_relative 'rpsl_algorithm'


module RpslComponentMetaModel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes


   class Component < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class ProcessingComponent < Component
   end

   class SensorComponent < Component
   end

   class Port < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class InputPort < Port
   end

   class OutputPort < Port
   end

end

RpslComponentMetaModel::Component.contains_many_uni 'port', RpslComponentMetaModel::Port, :lowerBound => 1 
RpslComponentMetaModel::Component.has_many 'component_property_prototype', RpslConceptualSpaceMetaModel::Prototype
RpslComponentMetaModel::Component.has_many 'QoS', RpslConceptualSpaceMetaModel::Prototype 
RpslComponentMetaModel::ProcessingComponent.has_one 'algorithm', RpslAlgorithmMetaModel::Algorithm , :lowerBound => 1 
RpslComponentMetaModel::SensorComponent.has_one 'algorithm', RpslAlgorithmMetaModel::Algorithm 
RpslComponentMetaModel::Port.has_one 'port_type', RpslConceptualSpaceMetaModel::Concept, :lowerBound => 1 
RpslComponentMetaModel::Port.has_many 'port_prototype', RpslConceptualSpaceMetaModel::Prototype 
