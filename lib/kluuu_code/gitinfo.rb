module KluuuCode
  class GitInfo
    def initialize(repository)
      @repos = repository
    end

    def latest(short=true)
      Dir.chdir(@repos) do
      #git log --date="short" --pretty=format:%h-%cd -n 1
        IO.popen("git log --date='short' --pretty=format:%h-%cd -n 1") do |io|
          io.gets
        end
      end
    end
  end
end
