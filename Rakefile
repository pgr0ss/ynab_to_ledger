desc "Run the tests"
task :test do
  sh "bundle exec ruby *_test.rb"
end

desc "Check formatting"
task :check_formatting do
  sh "bundle exec rufo -c ."
end

task :default => [:test, :check_formatting]
