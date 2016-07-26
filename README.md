# yt-wakeru-kun
yt-wakeru-kun is the tool to convert a youtube movie to multiple animated gifs

# Requirement
- youtube-dl
- Imagemagick
- FFmpeg

# Usage

```
$ ruby yt-wakeru-kun.rb -i https://www.youtube.com/watch\?v\=X--xJyBDPAo
```

```
$ ruby yt-wakeru-kun.rb -i https://www.youtube.com/watch\?v\=X--xJyBDPAo --frame 30
```

```
$ ruby yt-wakeru-kun.rb -i https://www.youtube.com/watch\?v\=X--xJyBDPAo --frame 30 --dir '/tmp/hoge'
```

# Options

## Require

### -i
set a youtube movie url

## Option

### --frames
number of frames per a gif. Default number is 10.

### --dir
file output directory.Default is '/tmp'