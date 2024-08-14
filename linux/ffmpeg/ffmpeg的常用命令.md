FFmpeg 是一个开源的多媒体处理工具，可以处理音频、视频和其他多媒体文件和流。它支持多种视频和音频格式，强大且灵活，广泛用于媒体转换、合并、剪辑、压缩等任务。下面是一些常见的 FFmpeg 命令及其用途。

### 1. 查看文件信息

```bash
ffmpeg -i input.mp4
```

### 2. 格式转换

#### 转换视频格式

```bash
ffmpeg -i input.mp4 output.avi
```

#### 转换音频格式

```bash
ffmpeg -i input.mp3 output.wav
```

### 3. 提取音频

从视频中提取音频并保存为 MP3 格式：

```bash
ffmpeg -i input.mp4 -q:a 0 -map a output.mp3
```

### 4. 截取片段

截取视频片段（从 00:00:30 开始，截取 20 秒钟）：

```bash
ffmpeg -i input.mp4 -ss 00:00:30 -t 00:00:20 -c copy output.mp4
```

### 5. 视频压缩

压缩视频大小：

```bash
ffmpeg -i input.mp4 -vcodec h264 -acodec mp2 output.mp4
```

### 6. 音频和视频合并

将音频文件和视频文件合并：

```bash
ffmpeg -i input.mp4 -i input.mp3 -c:v copy -c:a aac output.mp4
```

### 7. 添加字幕

给视频添加字幕文件：

```bash
ffmpeg -i input.mp4 -vf "subtitles=subtitle.srt" output.mp4
```

### 8. 修改分辨率

改变视频的分辨率：

```bash
ffmpeg -i input.mp4 -vf scale=1280:720 output.mp4
```

### 9. 裁剪视频

裁剪视频（从左上角起，裁剪出 300x200 的区域）：

```bash
ffmpeg -i input.mp4 -vf "crop=300:200:0:0" output.mp4
```

### 10. 静音视频

去除视频中的音频：

```bash
ffmpeg -i input.mp4 -an output.mp4
```

### 11. 拼接视频

#### 拼接多个文件

首先创建一个文本文件 `filelist.txt`，内容如下：

```
file 'part1.mp4'
file 'part2.mp4'
file 'part3.mp4'
```

然后使用以下命令拼接：

```bash
ffmpeg -f concat -safe 0 -i filelist.txt -c copy output.mp4
```

### 12. 更改帧率

更改视频的帧率：

```bash
ffmpeg -i input.mp4 -r 30 output.mp4
```

### 13. 视频旋转

旋转视频：

```bash
ffmpeg -i input.mp4 -vf "transpose=1" output.mp4
```

参数 `transpose` 的值：
- `0`：顺时针旋转 90 度并垂直翻转
- `1`：顺时针旋转 90 度
- `2`：逆时针旋转 90 度
- `3`：逆时针旋转 90 度并垂直翻转

### 14. 添加水印

给视频添加图片水印：

```bash
ffmpeg -i input.mp4 -i watermark.png -filter_complex "overlay=10:10" output.mp4
```

参数 `overlay` 指定了水印的位置，`10:10` 表示距离左上角 10 像素的位置。

### 15. 创建视频缩略图

从视频中创建缩略图：

```bash
ffmpeg -i input.mp4 -ss 00:00:03 -vframes 1 thumbnail.png
```

### 16. 音频增益/降低

增益或降低音频音量：

```bash
ffmpeg -i input.mp4 -filter:a "volume=1.5" output.mp4  # 增加 50% 音量
ffmpeg -i input.mp4 -filter:a "volume=0.5" output.mp4  # 减少 50% 音量
```

### 17. 实时屏幕录制

录制屏幕视频：

#### 在 Linux 上

```bash
ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :0.0 output.mp4
```

#### 在 macOS 上

```bash
ffmpeg -f avfoundation -framerate 30 -i "1" output.mp4
```

### 总结

FFmpeg 是一个功能强大、用途广泛的多媒体处理工具。上面列举的常用命令只是它功能的一小部分。掌握这些基础命令，可以帮助你进行各种媒体处理任务。如果需要更复杂和高级的功能，可以查阅 FFmpeg 的官方文档和社区资源，以获得更多支持和帮助。