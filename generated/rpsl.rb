require 'rgen/metamodel_builder'

module RpslMetaModel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes

   COMPLEXITY = Enum.new(:name => 'COMPLEXITY', :literals =>[ :CONSTANT, :DOUBLE_LOG, :LINEAR, :EXPONENTIAL, :ANYTIME ])
   SIMILARITY_METRIC = Enum.new(:name => 'SIMILARITY_METRIC', :literals =>[ :EUCLIDIAN_DISTANCE, :JACCARD_DISTANCE ])
   REQUEST_SAMPLE_SPEC = Enum.new(:name => 'REQUEST_SAMPLE_SPEC', :literals =>[ :LIST_OF_SAMPLE, :SAMPLE_OF ])
   RPSL_PRIMITIVE_TYPE = Enum.new(:name => 'RPSL_PRIMITIVE_TYPE', :literals =>[ :RPSL_BOOLEAN, :RPSL_INT8, :RPSL_INT16, :RPSL_INT32, :RPSL_UINT32, :RPSL_INT64, :RPSL_UINT64, :RPSL_FLOAT32, :RPSL_FLOAT64, :RPSL_STRING ])

   class Component < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class Port < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class SensorComponent < Component
   end

   class ProcessingComponent < Component
   end

   class InputPort < Port
   end

   class OutputPort < Port
   end

   class PerceptionGraph < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class Element < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class Leaf < Element
   end

   class Node < Element
   end

   class Connection < RGen::MetamodelBuilder::MMBase
   end

   class Algorithm < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'complexity', RpslMetaModel::COMPLEXITY 
      has_attr 'doc', String 
   end

   class AlgorithmImplementation < Algorithm
   end

   class Category < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class Concept < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
   end

   class AbstractInstance < RGen::MetamodelBuilder::MMBase
      abstract
   end

   class Data < AbstractInstance
   end

   class Prototype < AbstractInstance
   end

   class Domain < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String 
   end

   class DomainDimension < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'unit', String 
   end

   class IntervalDimension < DomainDimension
   end

   class OrdinalDimension < DomainDimension
   end

   class NominalDimension < DomainDimension
   end

   class RatioDimension < DomainDimension
   end

   class PrototypeElement < RGen::MetamodelBuilder::MMBase
      has_attr 'value', Object 
   end

   class Interval < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String 
      has_attr 'doc', String 
      has_attr 'is_circular', Boolean 
      has_attr 'lower_bound', Object 
      has_attr 'upper_bound', Object 
      has_attr 'primitive_type', RpslMetaModel::RPSL_PRIMITIVE_TYPE, :lowerBound => 1 
      has_attr 'unit', Object 
   end

   class Request < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'request_sample_spec', RpslMetaModel::REQUEST_SAMPLE_SPEC, :lowerBound => 1 
   end

   class PrototypeRequest < Request
   end

   class ConstraintRequest < Request
   end

   class RequestSimilarity < RGen::MetamodelBuilder::MMBase
      has_attr 'similarity_metric', RpslMetaModel::SIMILARITY_METRIC, :lowerBound => 1 
      has_attr 'similarity_value', Object
   end

end

RpslMetaModel::Component.contains_many_uni 'port', RpslMetaModel::Port, :lowerBound => 1 
RpslMetaModel::Component.has_many 'component_property_prototype', RpslMetaModel::Prototype 
RpslMetaModel::Component.has_many 'QoS', RpslMetaModel::Prototype 
RpslMetaModel::Port.has_one 'port_type', RpslMetaModel::Concept, :lowerBound => 1 
RpslMetaModel::Port.has_many 'port_prototype', RpslMetaModel::Prototype 
RpslMetaModel::SensorComponent.has_one 'algorithm', RpslMetaModel::Algorithm 
RpslMetaModel::ProcessingComponent.has_one 'algorithm', RpslMetaModel::Algorithm, :lowerBound => 1 
RpslMetaModel::PerceptionGraph.contains_many_uni 'element', RpslMetaModel::Element, :lowerBound => 1 
RpslMetaModel::Element.has_one 'component', RpslMetaModel::Component, :lowerBound => 1 
RpslMetaModel::Node.contains_many_uni 'connection', RpslMetaModel::Connection, :lowerBound => 1 
RpslMetaModel::Connection.has_one 'element', RpslMetaModel::Element, :lowerBound => 1 
RpslMetaModel::Connection.has_one 'sink', RpslMetaModel::InputPort, :lowerBound => 1 
RpslMetaModel::Connection.has_one 'src', RpslMetaModel::OutputPort, :lowerBound => 1 
RpslMetaModel::Algorithm.has_one 'category', RpslMetaModel::Category, :lowerBound => 1 
RpslMetaModel::AlgorithmImplementation.has_many 'algorithm_property_prototype', RpslMetaModel::Prototype 
RpslMetaModel::Category.contains_many_uni 'subCategory', RpslMetaModel::Category 
RpslMetaModel::Concept.contains_many_uni 'subConcept', RpslMetaModel::Concept 
RpslMetaModel::Concept.has_many 'domain', RpslMetaModel::Domain, :lowerBound => 1 
RpslMetaModel::AbstractInstance.has_one 'concept', RpslMetaModel::Concept, :lowerBound => 1 
RpslMetaModel::Data.has_many 'prototype', RpslMetaModel::Prototype, :lowerBound => 1 
RpslMetaModel::Prototype.contains_many_uni 'prototype_element', RpslMetaModel::PrototypeElement, :lowerBound => 1 
RpslMetaModel::Domain.contains_many_uni 'dimension', RpslMetaModel::DomainDimension, :lowerBound => 1 
RpslMetaModel::IntervalDimension.has_one 'interval', RpslMetaModel::Interval, :lowerBound => 1 
RpslMetaModel::PrototypeElement.has_one 'prototype_dimension', RpslMetaModel::DomainDimension, :lowerBound => 1 
RpslMetaModel::PrototypeRequest.has_one 'request_similarity', RpslMetaModel::RequestSimilarity, :lowerBound => 1 
RpslMetaModel::PrototypeRequest.has_one 'request_prototype', RpslMetaModel::Prototype, :lowerBound => 1 
