require 'html-proofer'

task :test_links do
  puts "Testing Internal links"
  options = { 
    :assume_extension => true,
    :allow_missing_href => true,
    :disable_external => true,
    :check_html => true,
    :internal_domains => [ 'docs.konghq.com'],
    :parallel => { :in_process => 3}
   }
  HTMLProofer.check_directory("./dist", options).run
  puts "Testing Internal links completed"
end
