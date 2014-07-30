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
end

i = RpslMetaModel::InputPort.new()
p = RpslMetaModel::OutputPort.new()
pp = RpslMetaModel::OutputPort.new()
c = RpslMetaModel::ProcessingComponent.new(:name => "Component", :port => [pp, i])
s = RpslMetaModel::SensorComponent.new(:name => "Sensor", :port => [p])


cv = RpslValidation::ComponentValidation.new()
cv.validate_component(c)
cv.validate_component(s)



