# Assimilate is part of Endless Assimilation, which is like Continuous
# Integration, but more borg style.
#
# opts example:
#
#    ref: refs/heads/experimental/71854768/endless-assimilation
#    after: 6f093fb8103f2459592e0c0f15bce3834d85aa2e
#    before: '0000000000000000000000000000000000000000'
#    created: true
#    deleted: false
#    forced: true
#    compare: https://github.com/munen/voicerepublic_dev/commit/6f093fb8103f
#    commits:
#    - id: 6f093fb8103f2459592e0c0f15bce3834d85aa2e
#      distinct: true
#      message: initial job for endless assimilation
#      timestamp: '2014-06-16T10:48:35+02:00'
#      url: https://github.com/munen/voicerepublic_dev/commit/6f093fb8103f2459592e0c0f15bce3834d85aa2e
#      author:
#        name: phil
#        email: phil@branch14.org
#        username: branch14
#      committer:
#        name: phil
#        email: phil@branch14.org
#        username: branch14
#      added:
#      - app/jobs/assimilate.rb
#      removed: []
#      modified: []
#    head_commit:
#      id: 6f093fb8103f2459592e0c0f15bce3834d85aa2e
#      distinct: true
#      message: initial job for endless assimilation
#      timestamp: '2014-06-16T10:48:35+02:00'
#      url: https://github.com/munen/voicerepublic_dev/commit/6f093fb8103f2459592e0c0f15bce3834d85aa2e
#      author:
#        name: phil
#        email: phil@branch14.org
#        username: branch14
#      committer:
#        name: phil
#        email: phil@branch14.org
#        username: branch14
#      added:
#      - app/jobs/assimilate.rb
#      removed: []
#      modified: []
#    repository:
#      id: 13351188
#      name: voicerepublic_dev
#      url: https://github.com/munen/voicerepublic_dev
#      description: VoiceRepublic
#      homepage: http://voicerepublic.com
#      watchers: 0
#      stargazers: 0
#      forks: 0
#      fork: false
#      size: 47308
#      owner:
#        name: munen
#        email: munen@voicerepublic.com
#      private: true
#      open_issues: 15
#      has_issues: true
#      has_downloads: true
#      has_wiki: true
#      language: Ruby
#      created_at: 1381001815
#      pushed_at: 1402908548
#      master_branch: integration
#    pusher:
#      name: branch14
#      email: phil@branch14.org
#    
class Assimilate < Struct.new(:opts)
  def perform
    Assimilator.run(opts)
  end
end

