require 'uri'
require 'optparse'
require 'open3'

class Validation
  def initialize(args)
    @args = args
    @parsed_opts = {
      movie_url: nil,
      frames: 10,
      dir: '/tmp'
    }
  end

  def result
    parse_args
    valid_url(@parsed_opts[:movie_url])
    valid_frame(@parsed_opts[:frames])
    valid_dir(@parsed_opts[:dir])
    @parsed_opts
  rescue => e
    puts e
  end

  private
  def parse_args
    OptionParser.new do |opt|
      opt.on('-i MOVIE_URL') {|v| @parsed_opts[:movie_url] = v}
      opt.on('--frame [FRAMES_PER_GIF]') {|v| @parsed_opts[:frames] = v}
      opt.on('--dir [FILE_DIRECTORY]') {|v| @parsed_opts[:dir] = v}
      opt.parse!(@args)
    end
    @parsed_opts
  end

  def valid_url(uri)
    URI::parse(uri)
  rescue
    raise "invalid uri pattern"
  end

  def valid_frame(frame)
    raise "#{frame} is invalid value.\n--frame needs only integer > 0." if frame.to_i == 0
  end

  def valid_dir(dir)
    raise "#{dir} is not found" unless File.exist?(dir)
  end
end

class Generator
  def initialize(option)
    @opts = option
    @output_dir = @opts[:dir]
    @timestamp = Time.now.to_i
  end

  def run
    download
    split
    convert
    clean
  end

  private
  def download
    puts 'Downloading'
    o,e,s = Open3.capture3("youtube-dl #{@opts[:movie_url]} -o '#{output_file_template}'")
  end

  def split
    puts 'Splitting'
    o,e,s = Open3.capture3("ffmpeg -i #{downloaded_movie_name} -an -r 7 #{output_frame_name}")
  end

  def convert
    print 'Converting'
    frames = []
    index = 0
    Dir::entries(@output_dir).each do |file|
      if file =~ /png$/
        frames << file
        if frames.length > @opts[:frames].to_i
          print '.'
          o,e,s = Open3.capture3("convert -limit memory 256MB -limit disk 2GB -delay 10 -loop 0 #{frames.join(' ')} -resize 420x315 #{output_complete_name(index)}")
          frames = []
          index += 1
        end
      end
    end

    if frames.length > 0
      print '.'
      o,e,s = Open3.capture3("convert -limit memory 256MB -limit disk 2GB -delay 10 -loop 0 #{frames.join(' ')} -resize 420x315 #{output_complete_name(index)}")
    end
  end

  def clean
    puts "\nCleaning"
    Dir::entries(@output_dir).each do |file|
      if file !~ /complete/ && file =~ /#{@timestamp}/
        File.delete(file)
      end
    end
  end

  def output_file_template
    "#{@output_dir}/#{@timestamp}_%(id)s.%(ext)s"
  end

  def downloaded_movie_name
    Dir::entries(@output_dir).each do |file|
      if file =~ /.+\.(mp4|webm|mkv)/
        return file
      end
    end
  end

  def output_frame_name
    "#{@output_dir}/#{@timestamp}_frames_%05d.png"
  end

  def input_frame_template
    "#{@output_dir}/*.png"
  end

  def output_complete_name(index)
    "#{@output_dir}/#{@timestamp}_#{format("%04d", index)}_complete.gif"
  end
end

puts "==== [#{Time.now.year}/#{Time.now.month}/#{Time.now.day}] Start ===="

@validation = Validation.new(ARGV)
@generator = Generator.new( @validation.result )
@generator.run

puts "==== Finish ===="
