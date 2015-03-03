require_relative '../generated/rpsl'
require_relative '../repository/rpsl_repository'
require 'set'
require "matrix"
require 'diverge'

class Diverge
	def initialize(p, q)
		@p, @q = p, q

    	unless p.length == q.length
    	  debugger { "The two discrete distributions must have the same number of elements" }
    	end

    	#unless (p_sum = p.inject(&:+)) == 1
    	#  debugger { "Warning: the first argument does not sum to 1, the sum is #{p_sum.inspect}" }
    	#end

    	#unless (q_sum = q.inject(&:+)) == 1
      		#debugger { "Warning: the second argument does not sum to 1, the sum is #{q_sum.inspect}" }
    	#end
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

    def normalize_sample(min_x, max_x, sample)
    	z = ((sample - min_x) / (max_x - min_x)).round(5)
    	return z 
    end

    def compute_request_adaptation(request)
    	perception_graph_candidates = Array.new

    	if request.class == RpslMetaModel::PrototypeRequest 
    		#puts 'RequestEngine :: Received a PrototypeRequest'

		    request_proto_concept_name = request.request_prototype.concept.name
			
		    #p request.instance_variable_get("@#{:request_similarity}")

		    # Check whether the Concept expressed in the Request is available in the concept repository
    		if self.concept_repository.has_key?(request_proto_concept_name) != true		
    			raise 'RequestEngine :: Concept in the request prototype is NOT available'
    		end

    		# We iterate over each PerceptionGraph in the repository and assess the output of leaf elements
    		self.perception_graph_repository.each do |key, pg|
    			pg.element.select{ |e| e.class == RpslMetaModel::Leaf}.each do |element|
    				# Get all the output ports with a prototype associated 
		            element.component.port.select{ |p| p.class == RpslMetaModel::OutputPort and p.port_prototype.length > 0}.each do |op|
		            	
		            	port_prototypes = op.port_prototype

		            	# We check whether the Concept expressed in the Prototype of the OutputPort matches with the Prototype of the Request
		            	port_prototypes.each.select{ |p| p.concept.name == request_proto_concept_name}.each do |proto|
		            		
		            		# We need to decide which SIMILARITY_METRIC we would like to apply
		            		request_similarity = request.instance_variable_get("@#{:request_similarity}")	
		            		request_similarity_metric = request_similarity.instance_variable_get("@#{:similarity_metric}")

		       				case request_similarity_metric.to_s
		            			when "EUCLIDIAN_DISTANCE"

		            			# We need to check whether domain names plus dimension names and their numbers
		            			# are the same for the REQUEST and for the PROTOTYPE

		            			prototype_elements = proto.prototype_element
		            			request_prototype_elements = request.request_prototype.prototype_element 

		            			prototype_element_dimension_name_array = Array.new	
		            			request_prototype_element_dimension_name_array = Array.new

		            			prototype_element_domain_name_array = Array.new
		            			request_prototype_element_domain_name_array = Array.new	

		            			prototype_elements.each_with_index do |val, index|
		            				prototype_element_dimension_name_array << val.prototype_dimension.name 
		            				prototype_element_domain_name_array << val.domain.name
		            			end

		        	    		request_prototype_elements.each_with_index do |val, index|
		            				request_prototype_element_dimension_name_array << val.prototype_dimension.name
		            				request_prototype_element_domain_name_array << val.domain.name
		            			end

		            			a = prototype_element_dimension_name_array - request_prototype_element_dimension_name_array
		            			b = prototype_element_domain_name_array - request_prototype_element_domain_name_array


		            			if a.size == 0 && b.size == 0
		            				
		            				# We can compute now the distance

		            				# We need to normalize the data 
		            				# Min = 0
		            				# Max = 1000
		            				# z_i = x_i 0 - min(x) / max(x) - min(x)

		            				min_x = 0.0
		            				max_x = 921600.0

		            				#min_x = 0.0
		            				#max_x = 921600.0
		            				
		            				# Get all the values from the Request prototype and from the Prototype

									# Normalize all the data

									normalized_proto_elements = []
									normalized_req_proto_elements = []

									prototype_elements.each.select{ |p| p.instance_variable_get("@#{:domain}").to_s != "PerformanceSignatureConcept.number_of_markers"}.each do |el|
										normalized_proto_elements << self.normalize_sample(min_x, max_x, el.value)
									end
									
									request_prototype_elements.each.select{ |p| p.instance_variable_get("@#{:domain}").to_s != "PerformanceSignatureConcept.number_of_markers"}.each do |el|
										normalized_req_proto_elements << self.normalize_sample(min_x, max_x, el.value)
									end		

									distance = Diverge.new(normalized_proto_elements, normalized_req_proto_elements).js
									#distance = Diverge.new(normalized_proto_elements, normalized_req_proto_elements).corr
									perception_graph_candidates << PerceptionGraphCandidate.new(distance, pg)
		            			end	

								when "EUCLIDIAN_DISTANCE_KDL"		            				
		            			else 
		            				raise 'RequestEngine :: No similarity metric given in the request'	
		            		end

		            	end
		            end
    			end
    		end

    		return perception_graph_candidates
    	end

    	return perception_graph_candidates
    end


    def compute_request(request)
		  perception_graph_candidates = Array.new 
		  
		  # Check whether the Request is of type PrototypeRequest
		  if request.class == RpslMetaModel::PrototypeRequest
		    request_concept_name = request.request_prototype.concept.name
		    
		    puts "We received a Request for Concept: " + request_concept_name
		    
		    # Check whether the Concept expressed in the Request is available in the Concept repository
		    #if self.concept_repository.concepts.has_key?(request_concept_name) == true
		    if self.concept_repository.has_key?(request_concept_name) == true  
		      puts "Received Concept: " + request_concept_name + " is in Concept repository"
		      
		      # We iterate over each PerceptionGraph in the repository and assess the output of leaf elements
		      self.perception_graph_repository.each do |key, pg|
		        # We get the elements of the PG which are type of Leaf
		        #pg.element.select{ |e| e.class == RpslMetaModel::Leaf}.each do |element|

		        #pg.instance_variable_get("@#{:element}").select{ |e| e.class == RpslMetaModel::Leaf}.each do |element|

		        pg.element.select{ |e| e.class == RpslMetaModel::Leaf}.each do |element|
		            puts "Leaf" 
		            # Get all the output ports with a prototype associated 
		            element.component.port.select{ |p| p.class == RpslMetaModel::OutputPort and p.port_prototype.length > 0}.each do |op|
		              puts "We now investigate the following OutputPort: " + op.name 
		              
		              port_prototypes = op.port_prototype
		              
                  # First we need to check whether the Concept expressed in the Prototype of the OutputPort matches with the Prototype of the Request
		              port_prototypes.each.select{ |p| p.concept.name == request_concept_name}.each do |proto|
		                
		                p proto.class
		                puts "We now investigate the prototype." 
		                
		                # We only compute the distance if the number of elements is equal and similarity metric is Euclidian distance (Extension, set missing dimensions to ZERO, request dimensions need to be subset of prototype dimensions)
		                if proto.prototype_element.size == request.request_prototype.prototype_element.size and request.request_similarity.similarity_metric == :EUCLIDIAN_DISTANCE
		                  puts "yeah it fits"
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
  

	





