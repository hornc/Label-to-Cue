
HELP_TEXT = <<END

 Audacity label file to basic CUE converter
 Charles Horn, March 2011
 Outputs to STDOUT
 for Audacity labels see: http://audacity.sourceforge.net/onlinehelp-1.2/track_label.htm

 USAGE:
   label2cue <label_file>.txt [[INITIAL_TRACK_NUMBER(default=1)] [TARGET_WAVE_FILE]] [ > output.cue ]

END

# Display Help / Usage text if needed
if (["-h", "help", "h", "--help", "?"].include?(ARGV[0])) || (ARGV[0].nil?)
  print HELP_TEXT
  Process.exit
end

# Converts seconds (float) to cue file: mm:ss:ff , where ff is frames. 1s = 75 frames
def convert(secs)
  c = "#{pad(secs.to_i / 60)}:#{pad(secs.to_i % 60)}:#{pad((75 * (secs.to_f - secs.to_i)).to_i)}"
  return c
end

# Pads a number string to 2 characters by adding a "0"
def pad(n)
  return (n.to_s.length == 1) ? "0#{n}" : n
end

label_file = ARGV[0]

# Get starting track number
if !ARGV[1].nil?
  track = ARGV[1].to_i
else
  track = 1
end

audio_file = ARGV[2]

if File.exists?(label_file)
  f = File.new(label_file, "r")

  puts "PERFORMER \"\""
  puts "TITLE \"\""
  puts "FILE \"#{audio_file}\" WAVE"

  f.each_line do |l|
    l = l.split(/[\t\n]/)
    puts "  TRACK #{pad(track)} AUDIO"
    puts "\tTITLE \"#{l[2]}\""
    puts "\tINDEX 01 #{convert(l[0])}"
    track += 1
  end
  f.close
else
  puts "Audacity Label file #{label_file} not Found!"
end



