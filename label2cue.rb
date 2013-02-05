#!/usr/bin/env ruby

# Copyright 2011 Charles Horn
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

HELP_TEXT = <<END
 
 Audacity label file to basic CUE converter
 Copyright 2011 Charles Horn, Licensed under the GNU General Public License v.3
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
