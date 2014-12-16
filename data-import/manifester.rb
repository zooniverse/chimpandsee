require 'bson'
require 'json'

`rm -rf ./outputs`

inputs_path = "./inputs"
outputs_path = "./outputs"

# not final at all
files = Dir["#{inputs_path}/**/*.ASF"]
subjects = []
previews_per = 9

files.each.with_index do |file, index|
  id = BSON::ObjectId.new.to_s

  duration = `ffprobe -v error -show_format "#{file}"`.split("\n")[7].strip.split("=")[1].to_i.floor

  subject_path = "#{outputs_path}/#{id}"
  `mkdir -p "#{subject_path}/previews"`

  # Video conversion
  `ffmpeg -i "#{file}" #{subject_path}/#{id}.mp4`

  previews = []
  seconds_between = duration / previews_per
  (0..previews_per).each do |preview|
    screenshot_time = preview * seconds_between
    preview_path = "#{subject_path}/previews/#{id}-#{screenshot_time}.jpg"
    `ffmpeg -ss #{screenshot_time} -i "#{file}" -r 1 -t 1 #{preview_path}`
    previews << preview_path
  end

  subject = {
    id: id,
    location: {
      standard: "#{subject_path}/#{id}.mp4",
      previews: previews
    },
    metadata: {
      duration: duration
    }
  }
  subjects << subject
end

File.open("#{outputs_path}/manifest.json", "w"){|f| f.puts(JSON.dump(subjects))}
