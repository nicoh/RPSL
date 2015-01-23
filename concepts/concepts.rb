require_relative '../generated/rpsl'
require_relative '../generated/units'
require_relative '../core/request_engine'

base = Units::MultiDimensionalDimension.new(:dimensionality => 1, :dimension => :PlaneAngle)
deg = Units::Dimension.new(:name => "deg", :bases => [base]) 
degree = Units::SingularUnit.new(:dimension => deg)

hue_dim = RpslMetaModel::IntervalDimension.new(:name => "Hue", :interval => interval = RpslMetaModel::Interval.new(:name => "hue", :is_circular => true, :lower_bound => 0, :upper_bound => 360, :primitive_type => :RPSL_FLOAT32, :unit => degree))
saturation_dim = RpslMetaModel::IntervalDimension.new(:name => "Saturation", :interval => interval = RpslMetaModel::Interval.new(:name => "saturation", :is_circular => false, :lower_bound => 0, :upper_bound => 1, :primitive_type => :RPSL_FLOAT32))
value_dim = RpslMetaModel::IntervalDimension.new(:name => "Value", :interval => interval = RpslMetaModel::Interval.new(:name => "value", :is_circular => false, :lower_bound => 0, :upper_bound => 1, :primitive_type => :RPSL_FLOAT32))

red_dim = RpslMetaModel::IntervalDimension.new(:name => "Red", :interval => interval = RpslMetaModel::Interval.new(:name => "red", :is_circular => false, :lower_bound => 0, :upper_bound => 255, :primitive_type => :RPSL_INT8))
green_dim = RpslMetaModel::IntervalDimension.new(:name => "Green", :interval => interval = RpslMetaModel::Interval.new(:name => "green", :is_circular => false, :lower_bound => 0, :upper_bound => 255, :primitive_type => :RPSL_INT8))
blue_dim = RpslMetaModel::IntervalDimension.new(:name => "Blue", :interval => interval = RpslMetaModel::Interval.new(:name => "blue", :is_circular => false, :lower_bound => 0, :upper_bound => 255, :primitive_type => :RPSL_INT8))

hsv_color_domain = RpslMetaModel::Domain.new(:name => "Color", :dimension => [hue_dim, saturation_dim, value_dim])
rgb_color_domain = RpslMetaModel::Domain.new(:name => "Color", :dimension => [red_dim, green_dim, blue_dim])

red_concept = RpslMetaModel::Concept.new(:name => "Red", )



=begin
concept_apple = RpslMetaModel::Concept.new(:name => "Apple", :domain => [domain_color]) 

red_prototype = RpslMetaModel::PrototypeInstance.new(:instance_element => 
		[ RpslMetaModel::InstanceElement.new(:value => 255, :instance_dimension => red), 
		  RpslMetaModel::InstanceElement.new(:value => 0, :instance_dimension => green),
		  RpslMetaModel::InstanceElement.new(:value => 0, :instance_dimension => blue)])

crimson_prototype = RpslMetaModel::PrototypeInstance.new(:instance_element => 
		[ RpslMetaModel::InstanceElement.new(:value => 220, :instance_dimension => red), 
		  RpslMetaModel::InstanceElement.new(:value => 20, :instance_dimension => green),
		  RpslMetaModel::InstanceElement.new(:value => 60, :instance_dimension => blue)])

concept_apple.instance = [red_prototype, crimson_prototype]
concept_repository = [concept_apple]

s = RpslRequest::RequestSimilarity.new(SimilarityMetric::EUCLIDIAN_DISTANCE, 0)
r = RpslRequest::PrototypeRequest.new('Test', red_prototype, s, "Apple", RequestDataSpec::SAMPLE_OF)
r.request_concept = concept_apple

request_engine = RequestEngine::RequestEngine.new(concept_repository)
request_engine.compute_request(r)

=end
