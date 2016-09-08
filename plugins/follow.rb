on_event(:event) do |obj|
  config[:friends] << obj.source.id if obj.name == :follow
end
