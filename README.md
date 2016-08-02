# yt-wakeru-kun
yt-wakeru-kun is the tool to convert a youtube movie to multiple animated gifs

# Requirement
- youtube-dl
  - [download link](https://rg3.github.io/youtube-dl/download.html)
- Imagemagick
  - [download link](http://www.imagemagick.org/script/binary-releases.php)
- FFmpeg
  - [download link](https://ffmpeg.org/download.html)

# Usage

```
$ ./yt-wakeru-kun -i https://www.youtube.com/watch\?v\=X--xJyBDPAo
```

```
$ ./yt-wakeru-kun -i https://www.youtube.com/watch\?v\=X--xJyBDPAo --frame 30
```

```
$ ./yt-wakeru-kun -i https://www.youtube.com/watch\?v\=X--xJyBDPAo --frame 30 --dir '/tmp/hoge'
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