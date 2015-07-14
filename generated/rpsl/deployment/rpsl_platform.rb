require 'rgen/metamodel_builder'
require_relative '../rpsl_conceptual_space'

module RpslPlatformMetaModel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes


   class Platform < RGen::MetamodelBuilder::MMBase
      has_attr 'hostname', String, :lowerBound => 1 
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'doc', String 
      has_attr 'IP', String, :lowerBound => 1 
   end

   class Processor < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
   end

   class Memory < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
   end

   class Device < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
   end

   class Bus < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
   end

end

RpslPlatformMetaModel::Platform.contains_many_uni 'device', RpslPlatformMetaModel::Device 
RpslPlatformMetaModel::Platform.contains_many_uni 'processor', RpslPlatformMetaModel::Processor, :lowerBound => 1 
RpslPlatformMetaModel::Platform.contains_many_uni 'memory', RpslPlatformMetaModel::Memory 
RpslPlatformMetaModel::Platform.has_many 'bus', RpslPlatformMetaModel::Bus, :lowerBound => 1 
RpslPlatformMetaModel::Platform.has_many 'platform_property_prototype', RpslConceptualSpaceMetaModel::Prototype 
RpslPlatformMetaModel::Processor.has_one 'bus', RpslPlatformMetaModel::Bus, :lowerBound => 1 
RpslPlatformMetaModel::Processor.has_many 'processor_property_prototype', RpslConceptualSpaceMetaModel::Prototype 
RpslPlatformMetaModel::Memory.has_many 'memory_property_prototype', RpslConceptualSpaceMetaModel::Prototype 
RpslPlatformMetaModel::Device.has_many 'device_property_prototype', RpslConceptualSpaceMetaModel::Prototype 
RpslPlatformMetaModel::Bus.has_many 'bus_property_prototype', RpslConceptualSpaceMetaModel::Prototype  
