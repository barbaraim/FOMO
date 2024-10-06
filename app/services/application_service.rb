# https://dry-rb.org/gems/dry-initializer/3.0/

class ApplicationService
  extend Dry::Initializer

  def self.call(...) = new(...).call
end
