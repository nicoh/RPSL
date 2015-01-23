require_relative '../generated/rpsl'
require_relative '../core/request_engine'

red   = RpslMetaModel::IntervalDimension.new(:name => "Red", :interval => interval = RpslMetaModel::Interval.new(:name => "red", :isCircular => false, :lowerBound => 0, :upperBound => 255, :primitiveType => "INTEGER"))
green = RpslMetaModel::IntervalDimension.new(:name => "Green", :interval => interval = RpslMetaModel::Interval.new(:name => "green", :isCircular => false, :lowerBound => 0, :upperBound => 255, :primitiveType => "INTEGER"))
blue  = RpslMetaModel::IntervalDimension.new(:name => "Blue", :interval => interval = RpslMetaModel::Interval.new(:name => "blue", :isCircular => false, :lowerBound => 0, :upperBound => 255, :primitiveType => "INTEGER"))

domain_color = RpslMetaModel::Domain.new(:name => "Color", :dimension => [red, green, blue])
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
