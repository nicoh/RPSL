require_relative '../generated/rpsl'
require 'minitest/unit'

module RpslValidation
  class ComponentValidation
    include MiniTest::Assertions
   
      def validate_component (component)
        assert component.name.size != 0, 
          "RpslValidation::ComponentValidation ==> Component name of " + component.to_s + " is empty"
        
        if component.class == RpslMetaModel::SensorComponent
          assert component.port.each.select{|p| p.class == RpslMetaModel::OutputPort}.size >= 1, 
            "RpslValidation::ComponentValidation ==> Sensor Component " + component.to_s + " does not provide an output port"
        end
        
        if component.class == RpslMetaModel::ProcessingComponent
          assert component.port.each.select{|p| p.class == RpslMetaModel::OutputPort}.size >= 1, 
            "RpslValidation::ComponentValidation ==> Processing Component " + component.to_s + " does not provide an output port"
        
          assert component.port.each.select{|p| p.class == RpslMetaModel::InputPort}.size >= 1,
            "RpslValidation::ComponentValidation ==> Processing Component " + component.to_s + " does not provide an input port"
        end 
      end
  end
  
  class AlgorithmValidation
    include MiniTest::Assertions
    
    def validate_algorithm (algorithm)
      assert algorithm.name.size != 0,
        "RpslValidation::AlgorithmValidation ==> Algorithm name of " + algorithm.to_s + " is empty"
    end
    
  end
  
  class PerceptionGraphValidation
    include MiniTest::Assertions
    
    def validate_perception_graph (perception_graph)
      assert perception_graph.name.size != 0,
        "RpslValidation::PerceptionGraphValidation ==> Perception Graph name of " + perception_graph.to_s + " is empty"
    end
  end
  
  class ConceptValidation
    include MiniTest::Assertions
    
    def validate_concept (concept)
      assert concept.name.size != 0,
        "RpslValidation::ConceptValidation ==> Concept name of " + concept.to_s + " is empty"
    end
    
  end

  class PrototypeValidation
    include MiniTest::Assertions
    
    def validate_prototype (prototype)
      assert prototype.name.size != 0,
      "RpslValidation::PrototypeValidation ==> Prototype name of " + prototype.to_s + " is empty"
    end
    
  end
    
end

i = RpslMetaModel::InputPort.new()
p = RpslMetaModel::OutputPort.new()
pp = RpslMetaModel::OutputPort.new()
c = RpslMetaModel::ProcessingComponent.new(:name => "Component", :port => [pp, i])
s = RpslMetaModel::SensorComponent.new(:name => "Sensor", :port => [p])


cv = RpslValidation::ComponentValidation.new()
cv.validate_component(c)
cv.validate_component(s)



