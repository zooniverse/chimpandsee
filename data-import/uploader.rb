require 'json'
require 'aws-sdk'
require 'mime/types'

if ARGV[0].nil? || ARGV[1].nil?
  puts "Provide both an input path and output S3 key path."
  puts "ex: uploader.rb ./outputs subjects"
  exit
end

unless Dir.exists?(ARGV[0])
  puts "Provided local path doesn't exist."
  exit
end

class Uploader
  def initialize(local_path, remote_path)
    AWS.eager_autoload!
    AWS.config access_key_id: ENV['AMAZON_ACCESS_KEY_ID'], secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY']

    @bucket = AWS::S3.new.buckets['demo.zooniverse.org']
    @local_path = File.expand_path(local_path)
    @remote_path = remote_path
  end

  def upload(path)
    remote_path_chunk = path.gsub("#{@local_path}/", '')
    content_type = MIME::Types.of(path).first.simplified

    obj = @bucket.objects["#{@remote_path}/#{remote_path_chunk}"]
    obj.write(file: path, acl: :public_read, content_type: content_type) until obj.exists?
  rescue => e
    puts "Rescued #{ e.message }"
    retry
  end
end

# Probably gets only files?
files = Dir["#{File.expand_path(ARGV[0])}/**/*.*"]
total = files.length

uploader = Uploader.new(ARGV[0], ARGV[1])

files.each_slice(25).with_index do |list, i|
  puts "Uploading #{ [(i + 1) * 25, total].min } / #{ total }"
  threads = []
  
  list.each do |file|
    threads << Thread.new do
      uploader.upload(file)
    end
  end
  
  threads.each &:join
end; nil
