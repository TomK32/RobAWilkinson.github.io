namespace :assets do
  task :precompile do
    puts `bundle exec jekyll build`
  end
end
namespace :blog do
  desc "Generate a new blog post with a title. Ex: rake blog:post['My New Post']"
  task :post, [:title] do |t, args|
    date = Time.now.strftime("%G-%m-%d")
    title = args[:title].to_s.strip
      slug = title.split(' ').map{ |s| s.downcase }.join('-')
      puts slug
      file = './_posts/' + "#{date}-#{slug}.md"
      puts file
      File.open(file,'w') { |f| f.write("---\nlayout: post\ntitle: \"#{title}\"\n---\n\n\n") }
  end
end

