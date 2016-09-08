on_event(:event) do |obj|
  config[:friends].delete(obj.target.id) if obj.name == :unfollow
end
