require_relative '../generated/rpsl'
require 'set'

module RpslRepository
  class ConceptRepository
  
    def initialize(concepts, prototypes)
      @concepts = concepts
      @prototypes = prototypes
    end
    
    attr_reader :concepts
    attr_reader :prototypes
    
    attr_writer :concepts
    attr_writer :prototypes
    
  end
  
  class PerceptionGraphRepository
  
    def initialize(perception_graphs)
      @perception_graphs = perception_graphs
    end
    
    attr_reader :perception_graphs
    attr_writer :perception_graphs
  
    def print_perception_graph(name)
      
    end
    
    def print_perception_graph_repository()
      pp(self.perception_graphs)
    end
    
    
  end
end


module RequestEngine
  
  class PerceptionGraphCandidate
  
    def initialize(distance, perception_graph)
      @distance = distance
      @perception_graph = perception_graph
    end
    
    attr_reader :distance
    attr_reader :perception_graph
    
    attr_writer :distance
    attr_writer :perception_graph
  
  end
  
  class RequestEngine

		def initialize(concept_repository, perception_graph_repository)
			@concept_repository = concept_repository
			@perception_graph_repository = perception_graph_repository
		end
		
    attr_reader :concept_repository
    attr_reader :perception_graph_repository

    attr_writer :concept_repository 
    attr_writer :perception_graph_repository
    
    def print_repositories
      puts concept_repository
      puts perception_graph_repository
    end

    def compute_request(request)
		  perception_graph_candidates = Array.new 
		  
		  # Check whether the Request is of type PrototypeRequest
		  if request.class == RpslMetaModel::PrototypeRequest
		    request_concept_name = request.request_prototype.concept.name
		    
		    puts "We received a Request for Concept: " + request_concept_name
		    
		    # Check whether the Concept expressed in the Request is available in the Concept repository
		    if self.concept_repository.concepts.has_key?(request_concept_name) == true
		      
		      puts "Received Concept: " + request_concept_name + " is in Concept repository"
		      
		      # We iterate over each PerceptionGraph in the repository and assess the output of leaf elements
		      self.perception_graph_repository.perception_graphs.each do |pg|
		        
		        # We get the elements of the PG which are type of Leaf
		        pg.element.select{ |e| e.class == RpslMetaModel::Leaf}.each do |element|
		            
		            # Get all the output ports with a prototype associated 
		            element.component.port.select{ |p| p.class == RpslMetaModel::OutputPort and p.port_prototype.length > 0}.each do |op|
		              puts "We now investigate the following OutputPort: " + op.name 
		              
		              port_prototypes = op.port_prototype
		              
                  # First we need to check whether the Concept expressed in the Prototype of the OutputPort matches with the Prototype of the Request
		              port_prototypes.each.select{ |p| p.concept.name == request_concept_name}.each do |proto|
		                
		                puts "We now investigate the prototype."
		                
		                # We only compute the distance if the number of elements is equal and similarity metric is Euclidian distance (Extension, set missing dimensions to ZERO, request dimensions need to be subset of prototype dimensions)
		                if proto.prototype_element.size == request.request_prototype.prototype_element.size and request.request_similarity.similarity_metric == :EUCLIDIAN_DISTANCE
		                  elements = proto.prototype_element
		                  request_elements = request.request_prototype.prototype_element
		                  
		                  distance = 0.0
		                   
		                  elements.each_with_index do |val, index|
		                    
		                    # Check whether the type of dimension fits
		                    if val.prototype_dimension.class == request_elements[index].prototype_dimension.class  
		                      d = (val.value - request_elements[index].value) * (val.value - request_elements[index].value) 
		                      distance += d
		                    end
		                    
		                  end
		               
		                  distance = Math.sqrt(distance)
		                  perception_graph_candidates << PerceptionGraphCandidate.new(distance, pg)
		              end
		              end
		            end
		        end 
		        
		        
		        
		     end
          return perception_graph_candidates
		    
        end
		        
		      end
		  end
		  
		    
	end
end
  

	





