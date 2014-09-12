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
      
      # Check that a Connection connects only ports which have the same Concept (type)
      perception_graph.element.each do |el|
        if el.class == RpslMetaModel::Node and el.connection.size != 0
          el.connection.each do |c|
            assert c.sink.port_type.name == c.src.port_type.name, 
            "RpslValidation::PerceptionGraphValidation ==> Type between Connection " + c.to_s + " does not match. Source " + c.src.port_type.name.to_s + " Sink " + c.sink.port_type.name.to_s  
          end
         end
      end
    end
  end
  
  class ConceptValidation
    include MiniTest::Assertions
    
    def validate_concept (concept)
      assert concept.name.size != 0,
        "RpslValidation::ConceptValidation ==> Concept name of " + concept.to_s + " is empty"

      assert concept.subConcept.each.select{|c| c.name.size !=0 }.size == 0,
        "RpslValidation::ConceptValidation ==> A subconcept name of concept " + concept.to_s + " is empty"
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


