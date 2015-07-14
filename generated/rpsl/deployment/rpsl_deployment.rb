require 'rgen/metamodel_builder'
require_relative '../rpsl_perception_graph'
require_relative '../rpsl_component'
require_relative 'rpsl_platform'
require_relative 'rpsl_execution'

module RpslDeploymentMetaModel
   extend RGen::MetamodelBuilder::ModuleExtension
   include RGen::MetamodelBuilder::DataTypes


   class Deployment < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String, :lowerBound => 1 
   end

   class DeploymentElement < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String 
   end

   class AbstractComponentSet < RGen::MetamodelBuilder::MMBase
      abstract
      has_attr 'name', String, :lowerBound => 1 
   end

   class RosComponentSet < AbstractComponentSet
   end

   class RosNode < RGen::MetamodelBuilder::MMBase
      has_attr 'name', String 
   end
end

RpslDeploymentMetaModel::Deployment.contains_many_uni 'deployment_element', RpslDeploymentMetaModel::DeploymentElement, :lowerBound => 1 
RpslDeploymentMetaModel::Deployment.has_one 'perception_graph', RpslPerceptionGraphMetaModel::PerceptionGraph, :lowerBound => 1 
RpslDeploymentMetaModel::DeploymentElement.contains_one_uni 'component_set', RpslDeploymentMetaModel::AbstractComponentSet, :lowerBound => 1 
RpslDeploymentMetaModel::DeploymentElement.has_one 'platform', RpslPlatformMetaModel::Platform, :lowerBound => 1 
RpslDeploymentMetaModel::DeploymentElement.has_one 'execution_unit', RpslExecutionMetaModel::ExecutionUnit, :lowerBound => 1 
RpslDeploymentMetaModel::DeploymentElement.has_many 'component', RpslComponentMetaModel::Component, :lowerBound => 1 
RpslDeploymentMetaModel::RosComponentSet.has_many 'ros_node', RpslDeploymentMetaModel::RosNode, :lowerBound => 1 
