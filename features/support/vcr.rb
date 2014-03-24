require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
end

VCR.cucumber_tags do |t|
  t.tag  '@vcr', :record => :new_episodes # uses default record mode since no options are given
  t.tags '@disallowed_1', '@disallowed_2', :record => :none
end
