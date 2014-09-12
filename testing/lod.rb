require_relative '../generated/rpsl'
require_relative '../core/request_engine'
require_relative '../core/rpsl_validation'
require  'pp'

############### CONCEPTS ############### 
lod_density_dimension = RpslMetaModel::IntervalDimension.new(:name => "Density", :interval => interval = RpslMetaModel::Interval.new(:name => "Density", :is_circular => false, :lower_bound => 0, :upper_bound => "INFINITE", :primitive_type => "DOUBLE"))
lod_density_domain = RpslMetaModel::Domain.new(:name => "Density", :dimension => [lod_density_dimension])
lod_concept = RpslMetaModel::Concept.new(:name => "LevelOfDetail", :domain => [lod_density_domain])
z_dimension = RpslMetaModel::IntervalDimension.new(:name => "Z", :interval => interval = RpslMetaModel::Interval.new(:name => "Z", :is_circular => false, :lower_bound => "-INFINITE", :upper_bound => "+INFINITE", :primitive_type => "DOUBLE"))
y_dimension = RpslMetaModel::IntervalDimension.new(:name => "Y", :interval => interval = RpslMetaModel::Interval.new(:name => "Y", :is_circular => false, :lower_bound => "-INFINITE", :upper_bound => "+INFINITE", :primitive_type => "DOUBLE"))
x_dimension = RpslMetaModel::IntervalDimension.new(:name => "X", :interval => interval = RpslMetaModel::Interval.new(:name => "X", :is_circular => false, :lower_bound => "-INFINITE", :upper_bound => "+INFINITE", :primitive_type => "DOUBLE"))
xyz_domain = RpslMetaModel::Domain.new(:name => "XYZ", :dimension => [x_dimension, y_dimension, z_dimension])
red_dimension   = RpslMetaModel::IntervalDimension.new(:name => "Red", :interval => interval = RpslMetaModel::Interval.new(:name => "red", :is_circular => false, :lower_bound => 0, :upper_bound => 255, :primitive_type => "INTEGER"))
green_dimension = RpslMetaModel::IntervalDimension.new(:name => "Green", :interval => interval = RpslMetaModel::Interval.new(:name => "green", :is_circular => false, :lower_bound => 0, :upper_bound => 255, :primitive_type => "INTEGER"))
blue_dimension  = RpslMetaModel::IntervalDimension.new(:name => "Blue", :interval => interval = RpslMetaModel::Interval.new(:name => "blue", :is_circular => false, :lower_bound => 0, :upper_bound => 255, :primitive_type => "INTEGER"))
number_of_points_dimension = RpslMetaModel::IntervalDimension.new(:name => "NumberOfPoints", :interval => interval = RpslMetaModel::Interval.new(:name => "blue", :is_circular => false, :lower_bound => 0, :upper_bound => "+INFINITE", :primitive_type => "INTEGER"))
number_of_points_domain = RpslMetaModel::Domain.new(:name => "NumberOfPoints", :dimension => [number_of_points_dimension])
rgb_domain = RpslMetaModel::Domain.new(:name => "RGB", :dimension => [red_dimension, green_dimension, blue_dimension])
point_cloud_concept = RpslMetaModel::Concept.new(:name => "PointCloud", :domain => [rgb_domain,xyz_domain, number_of_points_domain])
######################################## 


############### PROTOTYPES ############### 
lod_prototype_high = RpslMetaModel::Prototype.new(:prototype_element => 
    [ RpslMetaModel::PrototypeElement.new(:value => 1000, :prototype_dimension => lod_density_dimension )] , :concept => lod_concept)
lod_prototype_small = RpslMetaModel::Prototype.new(:prototype_element => 
    [ RpslMetaModel::PrototypeElement.new(:value => 1, :prototype_dimension => lod_density_dimension)] , :concept => lod_concept)
##########################################
      
      
############### COMPONENTS AND PORTS ############### 
input_point_cloud = RpslMetaModel::InputPort.new(:name => "inputPointCloud", :port_type => point_cloud_concept)
output_point_cloud = RpslMetaModel::OutputPort.new(:name => "outputPointCloud", :port_type => point_cloud_concept)
output_lod_high = RpslMetaModel::OutputPort.new(:name => "outputLoD_high", :port_type => lod_concept, :port_prototype => [lod_prototype_high])
output_lod_small = RpslMetaModel::OutputPort.new(:name => "outputLoD_small", :port_type => lod_concept, :port_prototype => [lod_prototype_small])
point_cloud_subsampling_component_high = RpslMetaModel::ProcessingComponent.new(:name => "Subsampling", :port => [input_point_cloud, output_point_cloud, output_lod_high])
kinect_component = RpslMetaModel::SensorComponent.new(:name => "Kinect", :port => [output_point_cloud])
point_cloud_subsampling_component_small = RpslMetaModel::ProcessingComponent.new(:name => "Subsampling", :port => [input_point_cloud, output_point_cloud, output_lod_small])
#################################################### 


############### PERCEPTION GRAPHS ############### 
subsampling_leaf_high = RpslMetaModel::Leaf.new(:component => point_cloud_subsampling_component_high)
kinect_node = RpslMetaModel::Node.new(:component => kinect_component, :connection => [connection = RpslMetaModel::Connection.new(:element => subsampling_leaf_high, :src => output_point_cloud, :sink => input_point_cloud)])
pg_high = RpslMetaModel::PerceptionGraph.new(:name => "PG_HIGH_LOD", :element => [kinect_node, subsampling_leaf_high])

subsampling_leaf_small = RpslMetaModel::Leaf.new(:component => point_cloud_subsampling_component_small)
kinect_node_small = RpslMetaModel::Node.new(:component => kinect_component, :connection => [connection = RpslMetaModel::Connection.new(:element => subsampling_leaf_small, :src => output_point_cloud, :sink => input_point_cloud)])
pg_small = RpslMetaModel::PerceptionGraph.new(:name => "PG_SMALL_LOD", :element => [kinect_node, subsampling_leaf_small])
#################################################



########## VALIDATION #########
validation = RpslValidation::PerceptionGraphValidation.new()
validation.validate_perception_graph(pg_small) 
validation.validate_perception_graph(pg_high)
#################################################




############### REPOSITORIES AND REQUESTS ############### 
concepts = Hash.new
prototypes = Array.new
perception_graphs = Array.new


concepts[point_cloud_concept.name] = point_cloud_concept
concepts[lod_concept.name] = lod_concept

prototypes << lod_prototype_small
prototypes << lod_prototype_high

similarity = RpslMetaModel::RequestSimilarity.new(:similarity_metric => :EUCLIDIAN_DISTANCE, :similarity_value => 0)
request = RpslMetaModel::PrototypeRequest.new(:name => "MyRequest", :request_sample_spec => :LIST_OF_SAMPLE, :request_similarity => similarity, :request_prototype => lod_prototype_small)
#
#
perception_graphs << pg_small
perception_graphs << pg_high
#
concept_repository = RpslRepository::ConceptRepository.new(concepts,prototypes)
perception_graph_repository = RpslRepository::PerceptionGraphRepository.new(perception_graphs)
#
re = RequestEngine::RequestEngine.new(concept_repository, perception_graph_repository)
candidates = re.compute_request(request)



candidates.each do |c|
  puts c.perception_graph.name 
  puts c.distance
end
#
#puts 'hello world'
######################################################### 
