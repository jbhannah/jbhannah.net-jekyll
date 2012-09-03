desc 'Start Jekyll preview server and Compass watcher'
task :start do
  system "bundle exec foreman start -c compass=1,jekyll=1"
end

namespace :assets do
  desc 'Precompile assets'
  task :precompile do
    system "bundle exec compass compile -c compass.rb"
    system "bundle exec jekyll"
  end
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
      system "touch #{filename}"

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

      system "vi -c start + #{filename}"
    end
  end
end
