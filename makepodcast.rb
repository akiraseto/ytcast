#!/usr/bin/env ruby

require 'time'
require 'nkf'

abort "Usage:#{$0} PodcastTitle PublicURL FilesDir" if ARGV.length < 3

title = NKF.nkf('-w', ARGV[0])
location = ARGV[1]
filesDir = ARGV[2]
thumbnail = "thumb_audio.png"
host_ip = `hostname -I | cut -f1 -d' '`
host_ip = host_ip.gsub(/\n/) { "" }

files = [];
Dir.glob(File.join(filesDir, '*.{mp3,m4a,aac,mp4}')) do |path|
  name = File.basename(path, File.extname(path))
  item = { 'path'   => path,
           'name'   => name,
           'fname'  => File.basename(path),
           'time'   => File.ctime(path),
           'length' => File.size(path) }
  files << item
end

files = files.sort do |a, b|
  a['time'] <=> b['time']
end

if filesDir =~ /movie/
  thumbnail = "thumb_movie.png"
end

puts <<EOS
<?xml version="1.0" encoding="utf-8"?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" version="2.0">
  <channel>
    <title>#{title}</title>
    <itunes:owner/>
    <itunes:image href="http://#{host_ip}/podcast/#{thumbnail}"/>
    <itunes:category text="youtube"/>
EOS

files.each do |item|
  url = location + item['fname']

  if (/\.m4a$/ =~ item['fname']) then
    mime = 'audio/m4a'
  else
    # mime = 'audio/mp4'
    mime = 'video/mp4'
  end

  puts <<-EOS
    <item>
      <title>#{item['name']}</title>
      <enclosure url="#{url}"
                 length="#{item['length']}"
                 type="#{mime}" />
      <guid isPermaLink="true">#{url}</guid>
      <pubDate>#{item['time'].rfc822}</pubDate>
    </item>
  EOS
end

puts <<EOS
  </channel>
</rss>
EOS
