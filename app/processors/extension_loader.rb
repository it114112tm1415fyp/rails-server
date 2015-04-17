module ExtensionLoader
	class << self
		def load
			Dir[File.expand_path('../../../extensions/*.rb', __FILE__)].each { |x| Kernel.require(x) }
			Dir[File.expand_path('../../../static_processor/*.rb', __FILE__)].each { |x| Kernel.require(x) }
		end
		def reload
			Dir[File.expand_path('../../../extensions/*.rb', __FILE__)].each { |x| Kernel.load(x) }
			Dir[File.expand_path('../../../static_processor/*.rb', __FILE__)].each { |x| Kernel.load(x) }
		end
	end
end
