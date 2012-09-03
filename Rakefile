desc 'Start Jekyll preview server and Compass watcher'
task :start do
  sh %{ foreman start }
end

task :generate do
  system "bundle exec compass compile -c compass.rb"
  system "bundle exec jekyll"
end

namespace :new do
  task :post, [:title, :format, :category] do |t, args|
    require 'active_support/inflector'
    args.with_defaults(format: 'md')

    filename  = '_posts/' + Time.now.strftime('%F')
    filename += '-' + args.title.parameterize + '.' + args.format

    if File.exists?(filename)
      raise "A post with that date, title, and format already exists!"
    else
      sh %{ touch #{filename} }

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

      sh %{ vi -c start + #{filename} }
    end
  end
end
