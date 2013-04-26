task default: "assets:precompile"

namespace :assets do
  desc 'Precompile assets'
  task :precompile do
    sh "bundle exec jekyll"
  end
end

namespace :new do
  desc 'Create a new post'
  task :post, [:title, :format] do |t, args|
    require 'active_support/inflector'
    args.with_defaults(format: 'md')

    filename  = '_posts/' + Time.now.strftime('%F')
    filename += '-' + args.title.parameterize + '.' + args.format

    if File.exists?(filename)
      raise "A post with that date, title, and format already exists!"
    else
      sh "touch #{filename}"

      front = []
      front << "---"
      front << "layout:    post"
      front << "title:     #{args.title.titleize}"
      front << "published: false"
      front << "---"
      front << "" << "" << ""

      f = File.new(filename, 'w+')
      f << front.join("\n")
      f.close

      sh "vi -c start + #{filename}"
    end
  end
end

desc 'Start Jekyll preview server'
task :start do
  sh "rm -rf _site/*"
  exec "bundle exec foreman start -c jekyll=1"
end
