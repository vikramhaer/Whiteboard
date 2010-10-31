class Board < ActiveRecord::Base
	include ActionController::UrlWriter
  has_many :layers
	before_create :create_layer
	
	def create_layer
		l = Layer.new
		layers << l
		return l
	end 
	
  def base_layer
    layers[0]
  end 
	
	def token
		return base_layer.token
	end
	
	def owner_link
		return polymorphic_path(self, :token => token)
	end
	
	def viewer_link
		return polymorphic_path(self)
	end
	
	def collaborator_link
		l = create_layer
		l.save
		return polymorphic_path(self, :token => l.token)
	end
	
	def permission(token_param)
		if token_param == token
			return :owner
		elsif layer_from_token(token_param)	# return nil if it's viewer
			return :collaborator
		else
			return :viewer
		end
	end
	
	def layer_from_token(token_param)
		return layers.find_by_token(token_param)
	end
	
end
