require 'rgen/metamodel_builder'

module RpslConceptualSpaceMetaModel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes

   RPSL_PRIMITIVE_TYPE = Enum.new(:name => 'RPSL_PRIMITIVE_TYPE', :literals =>[ :RPSL_STRING, :RPSL_FLOAT32, :RPSL_FLOAT64, :RPSL_INT8, :RPSL_INT16, :RPSL_INT32, :RPSL_UINT32, :RPSL_INT64, :RPSL_UINT64, :RPSL_FLOAT32, :RPSL_FLOAT64, :RPSL_BOOLEAN ])

   class Concept < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
      has_attr 'uuid', String, :lowerBound => 1 
   end

   class Domain < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
   end

   class DomainDimension < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'unit', Object 
   end

   class NominalDimension < DomainDimension
   end

   class OrdinalDimension < DomainDimension
   end

   class IntervalDimension < DomainDimension
   end

   class RatioDimension < DomainDimension
   end

   class Interval < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String 
      has_attr 'doc', String 
      has_attr 'lower_bound', Object 
      has_attr 'upper_bound', Object 
      has_attr 'primitive_type', RpslConceptualSpaceMetaModel::RPSL_PRIMITIVE_TYPE 
      has_attr 'unit', String 
      has_attr 'is_circular', Boolean 
   end

   class Ordinal < RGen::MetamodelBuilder::MMBase
      has_attr 'is_constant', Boolean 
      has_attr 'value', Object 
      has_attr 'name', String 
      has_attr 'has_rank', Boolean 
      has_attr 'rank', Object 
      has_attr 'primitive_type', RpslConceptualSpaceMetaModel::RPSL_PRIMITIVE_TYPE 
   end

   class AbstractInstance < RGen::MetamodelBuilder::MMBase
      abstract
   end

   class Data < AbstractInstance
   end

   class Prototype < AbstractInstance
   end

   class PrototypeElement < RGen::MetamodelBuilder::MMBase
      has_attr 'value', Object 
   end

end

RpslConceptualSpaceMetaModel::Concept.has_many 'domain', RpslConceptualSpaceMetaModel::Domain, :lowerBound => 1 
RpslConceptualSpaceMetaModel::Concept.contains_many_uni 'subConcept', RpslConceptualSpaceMetaModel::Concept 
RpslConceptualSpaceMetaModel::Domain.contains_many_uni 'dimension', RpslConceptualSpaceMetaModel::DomainDimension, :lowerBound => 1 
RpslConceptualSpaceMetaModel::OrdinalDimension.has_many 'ordinal', RpslConceptualSpaceMetaModel::Ordinal, :lowerBound => 1 
RpslConceptualSpaceMetaModel::IntervalDimension.has_one 'interval', RpslConceptualSpaceMetaModel::Interval, :lowerBound => 1 
RpslConceptualSpaceMetaModel::AbstractInstance.has_one 'concept', RpslConceptualSpaceMetaModel::Concept, :lowerBound => 1 
RpslConceptualSpaceMetaModel::Data.has_many 'prototype', RpslConceptualSpaceMetaModel::Prototype, :lowerBound => 1 
RpslConceptualSpaceMetaModel::Prototype.contains_many_uni 'prototype_element', RpslConceptualSpaceMetaModel::PrototypeElement, :lowerBound => 1 
RpslConceptualSpaceMetaModel::PrototypeElement.has_one 'prototype_dimension', RpslConceptualSpaceMetaModel::DomainDimension, :lowerBound => 1 
RpslConceptualSpaceMetaModel::PrototypeElement.has_one 'domain', RpslConceptualSpaceMetaModel::Domain, :lowerBound => 1 
