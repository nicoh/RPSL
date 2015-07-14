require 'rgen/metamodel_builder'
require_relative 'rpsl_component'
require_relative 'rpsl_conceptual_space'

module RpslPerceptionGraphMetaModel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes


   class PerceptionGraph < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'uuid', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class Element < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String 
      has_attr 'doc', String 
   end

   class Leaf < Element
   end

   class Node < Element
   end

   class Connection < RGen::MetamodelBuilder::MMBase
   end

end

RpslPerceptionGraphMetaModel::PerceptionGraph.contains_many_uni 'element', RpslPerceptionGraphMetaModel::Element, :lowerBound => 1 
RpslPerceptionGraphMetaModel::PerceptionGraph.has_many 'perception_graph_property_prototype', RpslConceptualSpaceMetaModel::Prototype  
RpslPerceptionGraphMetaModel::Element.has_one 'component', RpslComponentMetaModel::Component, :lowerBound => 1 
RpslPerceptionGraphMetaModel::Node.contains_many_uni 'connection', RpslPerceptionGraphMetaModel::Connection, :lowerBound => 1 
RpslPerceptionGraphMetaModel::Connection.has_one 'element', RpslPerceptionGraphMetaModel::Element, :lowerBound => 1 
RpslPerceptionGraphMetaModel::Connection.has_one 'sink', RpslComponentMetaModel::InputPort, :lowerBound => 1 
RpslPerceptionGraphMetaModel::Connection.has_one 'src', RpslComponentMetaModel::OutputPort, :lowerBound => 1 
