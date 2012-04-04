HELP_TEXT = <<END

 Audacity label file to basic CUE converter
 Charles Horn, March 2011
 Outputs to STDOUT
 for Audacity labels see: http://audacity.sourceforge.net/onlinehelp-1.2/track_label.htm

 USAGE:
   label2cue <label_file>.txt [[TARGET_WAVE_FILE] [INITIAL_TRACK_NUMBER(default=1)]] [ > output.cue ]

END

# Display Help / Usage text if needed
if (["-h", "help", "h", "--help", "?"].include?(ARGV[0])) || (ARGV[0].nil?)
  print HELP_TEXT
  Process.exit
end

# Converts seconds (float) to cue file: mm:ss:ff , where ff is frames. 1s = 75 frames
def convert(secs)
  s = secs.to_i
  "%02d:%02d:%02d" % [s / 60, s % 60, 75 * (secs.to_f - s)]
end

label_file = ARGV[0]
audio_file = ARGV[1]
track      = ARGV[2].nil? ? 1 : ARGV[2].to_i  # Get starting track number


if File.exists?(label_file)
  f = File.new(label_file, "r")

  puts "PERFORMER \"\""
  puts "TITLE \"\""
  puts "FILE \"#{audio_file}\" WAVE"

  f.each_line do |l|
    l = l.split(/[\t\n]/)
    puts "  TRACK %02d AUDIO" % track
    puts "\tTITLE \"#{l[2]}\""
    puts "\tINDEX 01 #{convert(l[0])}"
    track += 1
  end
  f.close
else
  puts "Audacity Label file #{label_file} not Found!"
end
