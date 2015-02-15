class Datastore
  class << self
    RepositoryNotFound = Class.new(StandardError)

    def repositories
      @repositories ||= {}
    end

    def register(key, repository)
      @repositories[key] = repository
    end

    private

    def method_missing(*args)
      repo_key = args.first
      repositories.fetch repo_key
    rescue
      raise RepositoryNotFound.new("Missing Repository: #{repo_key}")
    end
  end
end
