将图片压缩成视频

ffmpeg -f image2 -r 15 -i fram%d.png -c:v copy -b:v 64K test.mp4

 -r 帧率

 -i 输入 这里的%05d代表所有以五位数字命名的图片xxxxx.jpg，按照有小到大顺序输入

最后为输出路径及视频文件名

https://blog.csdn.net/sinat_36502563/article/details/103103411?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1.not_use_machine_learn_pai&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromBaidu-1.not_use_machine_learn_pai



从视频中提取音频

ffmpeg -i third12.mp4 -q:a 0 -map a test.mp3

ffmpeg -i third12.mp4 -vn -acodec copy test.mp3

https://www.cnblogs.com/CodeAndMoe/p/13360011.html



将音频压缩到视频

ffmpeg -i test.mp4 -i test.mp3 -codec copy -shortest output.mp4

https://cloud.tencent.com/developer/ask/101444