# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tumblr}
  s.version = "0.0.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Kreeftmeijer"]
  s.date = %q{2009-07-11}
  s.email = %q{jeff@kreeftmeijer.nl}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/tumblr.rb",
    "lib/tumblr/post.rb",
    "lib/tumblr/request.rb",
    "lib/tumblr/user.rb",
    "test/test_helper.rb",
    "test/tumblr_test.rb"
  ]
  s.homepage = %q{http://github.com/jeffkreeftmeijer/tumblr}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Tumblr API wrapper}
  s.test_files = [
    "test/test_helper.rb",
    "test/tumblr_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
