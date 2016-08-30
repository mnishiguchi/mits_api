class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  # Triggered by the router for the constraint.
  # Checks if the default version is required or the Accept header matches the given string.
  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.mits.v#{@version}")
  end
end
