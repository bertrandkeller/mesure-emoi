
require 'rake/clean'

$site_url = "http://bertrandkeller.github.io/mesure-emoi/"
$site_name = "mesure-emoi"

$remote = "https://github.com/bertrandkeller/mesure-emoi.git"

desc 'Testing (draft - local server)'
task :testing => [:draft, :run]

desc 'Light preview (deploy - local server)'
task :lpreview => [:deploy, :run]

desc 'Preview (release version - local server)'
task :preview => [:release, :run]

desc 'Publish the site, ping sites and push code'
task :publish => [:publish_only, :ping_sitemap, :pingomatic, :push]

desc 'Publish the site'
task :publish_only => [:clean, :release, :build]

desc 'Configure to draft (dev)'
task :draft do
  puts "* Configuring _config.yml to draft... [quick_draft: yes, public: no]"
  edit_config("quick_draft", "yes")
  edit_config("public", "no")
end

desc 'Configure to deploy'
task :deploy do
  puts "* Configuring _config.yml to deploy (dev)... [quick_draft: no, public: no]"
  edit_config("quick_draft",  "no")
  edit_config("public", "no")
end

desc 'Configure to release'
task :release do
  puts "* Configuring _config.yml for a release (public) version... [quick_draft: no, public: yes]"
  edit_config("quick_draft",  "no")
  edit_config("public", "yes")
end

desc 'Run Jekyll in development mode'
task :run do
  puts '* Running Jekyll with auto-generation and server'
  sh "jekyll --auto --server"
end

desc 'Run Jekyll to generate the site'
task :build do
  puts '* Generating static site with Jekyll'
  sh "jekyll --no-auto"
end

desc 'Upload the _site content'
task :send do
  # Should test if _site/ exists
  sh "rsync -avzh --progress --del _site/ #{$remote}"
end

# original code (Google only) by Jose Diaz-Gonzalez (http://github.com/josegonzalez/josediazgonzalez.com)
desc 'Notify Google, Yahoo and Bing of the new sitemap'
task :ping_sitemap do
  begin
    require 'net/http'
    require 'uri'
    sitemap = URI.escape("#{$site_url}/sitemap.xml")
    puts '* Pinging Google about our sitemap'
    Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' + sitemap)
    puts '* Pinging Yahoo about our sitemap'
    Net::HTTP.get('search.yahooapis.com', '/SiteExplorerService/V1/ping?sitemap=' + sitemap)
    puts '* Pinging Bing about our sitemap'
    Net::HTTP.get('www.bing.com', '/webmaster/ping.aspx?sitemap=' + sitemap)
  rescue LoadError
    puts 'Error! Could not ping about the sitemap, because Net::HTTP or URI could not be found.'
  end
end

# code by Jose Diaz-Gonzalez (http://github.com/josegonzalez/josediazgonzalez.com)
desc 'Ping pingomatic'
task :pingomatic do
  begin
    require 'xmlrpc/client'
    puts '* Pinging ping-o-matic'
    XMLRPC::Client.new('rpc.pingomatic.com', '/').call('weblogUpdates.extendedPing', $site_name, $site_url, "#{$site_url}/atom.xml")
  rescue LoadError
    puts 'Error! Could not ping ping-o-matic, because XMLRPC::Client could not be found.'
  end
end

task :check_git => :draft do
  status = `git status --porcelain --untracked-files=no`
  if status =~ /\S/
    puts " ! Warning: working directory is not clean. Please commit!!"
    puts " ! and don't forget to run 'rake push' after the commit."
  end
end

desc 'Git push to all remotes'
task :push => :check_git do
  remotes = `git remote`.split
  puts "* Pushing code to all remote repositories (#{remotes.join(", ")})"
  edit_config("env",  "production")
  puts "change environnement value to production"
  sh "git pull"
  sh "git add ."
  sh "git commit -a -m \"deploy\""
  remotes.each do |remote|
    sh "git push #{remote} --all"
  edit_config("env", "developement")
  puts "change environnement value to developement"
  end
end

## Helpers
def edit_config(option_name, value)
  config = File.read("_config.yml")
  regexp = Regexp.new('(^\s*' + option_name + '\s*:\s*)(\S+)(\s*)$')
  config.sub!(regexp,'\1'+value+'\3')
  File.open("_config.yml", 'w') {|f| f.write(config)}
end