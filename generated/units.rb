require 'rgen/metamodel_builder'

module Units
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes
   annotation :source => "http://www.eclipse.org/emf/2002/Ecore", :details => {'invocationDelegates' => 'http://www.eclipse.org/emf/2002/Ecore/OCL/Pivot', 'settingDelegates' => 'http://www.eclipse.org/emf/2002/Ecore/OCL/Pivot', 'validationDelegates' => 'http://www.eclipse.org/emf/2002/Ecore/OCL/Pivot'}

   BaseDimension = Enum.new(:name => 'BaseDimension', :literals =>[ :Length, :Mass, :Time, :Current, :Temperature, :Amount, :LuminousIntensity, :PlaneAngle, :SolidAngle ])

   class OneDimensionalUnit < RGen::MetamodelBuilder::MMBase
      abstract
      has_attr 'name', String, :lowerBound => 1 
      has_attr 'unitName', String, :lowerBound => 1 
      has_attr 'documentation', String, :defaultValueLiteral => "" 
      has_attr 'scale', Float, :defaultValueLiteral => "1.0", :lowerBound => 1 
   end

   class Dimension < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
   end

   class ScaledUnit < OneDimensionalUnit
   end

   class SingularUnit < OneDimensionalUnit
   end

   class Quantity < RGen::MetamodelBuilder::MMBase
      has_attr 'value', Float, :lowerBound => 1 
   end

   class MultiDimensionalUnit < RGen::MetamodelBuilder::MMBase
      has_attr 'dimensionality', Integer, :defaultValueLiteral => "1", :lowerBound => 1 
   end

   class MultiDimensionalDimension < RGen::MetamodelBuilder::MMBase
      has_attr 'dimensionality', Integer, :lowerBound => 1 
      has_attr 'dimension', Units::BaseDimension, :lowerBound => 1 
   end

end

Units::Dimension.contains_many_uni 'bases', Units::MultiDimensionalDimension, :lowerBound => 1 
Units::ScaledUnit.has_one 'base', Units::SingularUnit, :lowerBound => 1 
Units::SingularUnit.has_one 'dimension', Units::Dimension, :lowerBound => 1 
Units::Quantity.contains_many_uni 'units', Units::MultiDimensionalUnit, :lowerBound => 1 
Units::MultiDimensionalUnit.has_one 'unit', Units::OneDimensionalUnit, :lowerBound => 1 
