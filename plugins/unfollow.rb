on_event(:event) do |obj|
  if obj.name == :unfollow
    @config[:friends].delete(obj.target.id)
  end
end
