### **一、流编辑器 sed 与命令 sed**

Linux 中，常使用流编辑器 sed 进行文本替换工作。与常使用的交互式编辑器（如vim）不同，sed 编辑器以批处理的方式来编辑文件，这比交互式编辑器快得多，可以快速完成对数据的编辑修改。

**一般来说，sed 编辑器会执行以下操作：**

1）一次从输入中读取一行数据；

2）根据所提供的编辑器命令匹配数据；

3）按照命令修改流中的数据；

4）将新的数据输出到 STDOUT。

在 sed 编辑器匹配完一行数据后，它会读取下一行数据并重复这个过程，直到处理完所有数据。使用 sed 命令打开一个 sed 编辑器。sed 命令的格式如下：

```
sed [options] edit_commands [file]　　　　# [ ] 中的内容为可选可不选
```

其中，options 为命令选项，选择不同的 options 可以修改 sed 命令的行为，主要有 3 个选项：

1）-e 选项： 在处理输入时，将 script 中指定的编辑命令添加到已有的命令中。通俗的说，就是在 sed 后面直接添加编辑命令：

```
sed -e 'edit_commands' [files]
```

sed 命令在默认情况下使用的是 -e 选项。当只有一个编辑命令时，-e 选项可以省略；但是当要在一条 sed 语句中执行多个编辑命令时，就需要使用 -e 选项了：

```
sed -e 's/root/ROOT/g; s/bin/BIN/g' /etc/passwd    　　 # 使用 sed 同时执行两条编辑命令（本文大部分用例都直接使用 /etc/passwd 文件）

sed -e 's/root/ROOT/g' -e 's/bin/BIN/g' /etc/passwd 　　# 使用 sed 同时执行两条编辑命令
```

2）-f 选项：在处理输入时，将 file 中指定的编辑命令添加到已有的命令中：

前面提到，在需要同时执行多条编辑命令时，可以使用 -e 选项。但是当所需要执行的编辑命令数量很多时，每次使用 sed 时一行一行地敲显然不是很方便，这时可以将所用到的 sed 编辑命令写入一个文件，然后使用 sed -f 选项来指定读取该文件：

```
$ cat script.sed
$ s/root/ROOT/
$ s/bin/BIN/
$ s/home/HOME/
```

```
sed -f script.sed /etc/passwd
```

3）-n 选项： 不产生命令输入：

```
sed -n 's/root/ROOT/' /etc/passwd
```
使用 -n 选项不会将流编辑器的内容输出到 STDOUT，通常将 -n 选项与 p 命令结合起来使用，以只打印被匹配的行。

除了这三个选项外，sed 编辑器还提供了许多命令，用来进行更详细的操作，简单列一下，后面再仔细介绍：

| 命令 | 描述                   |
| ---- | ---------------------- |
| s    | 文本替换操作           |
| d    | 删除操作               |
| i    | 插入操作               |
| a    | 附加操作               |
| c    | 将一行文本修改为新的行 |
| y    | 逐字符替换             |
| p    | 打印文本行             |
| =    | 打印行号               |
| w    | 向文件中写入数据       |
| r    | 从文件中读取数据       |

### **二、使用 sed 命令进行文本替换**

sed 使用 s 命令来进行文本替换操作，基本格式如下：

```
sed 's/srcStr/dstStr/' file
```

其中，srcStr 为想要替换的文本，dstStr 为将要替换成的文本。使用 s 命令时，sed 编辑器会在一行一行地读取文件 file，并在每行查找文本 srcStr，如果找到了，则将该处的 srcStr 替换为 dstStr。

/ 字符为界定符，用于分隔字符串（sed 编辑器允许使用其他字符作为替换命令中的字符串分隔符）：

```
sed 's!/bin/bash!/BIN/BASH!' /etc/passwd    # 使用 ! 作为字符串分隔符
```

默认情况下，替换命令只会替换掉目标文本在每行中第一次出现的地方。若想要替换掉每行中所有匹配的地方，可以使用替换标记 g。替换标记放在编辑命令的末尾。除了 g 外，还有几种替换标记：

**1）数字：**指明替换掉第几次匹配到的文本，没有设置这个标记时，默认是替换第一次匹配的文本：

```
sed 's/root/ROOT/2' /etc/passwd
```

这行命令将 /etc/passwd 文件中每行的第 2 个 root 替换为 ROOT；

**2）g ：**替换所有匹配到的文本：

```
sed 's/root/ROOT/g' /etc/passwd
```

这行命令将 /etc/passwd 文件中的 root，全部替换为 ROOT；

**3）p ：**打印与替换命令中指定模式（srcStr）相匹配的行：

```
sed 's/root/ROOT/p' /etc/passwd
```

执行这命令，会在 STDOUT 上看到包含有 root 的行被输出了两次，一次是 sed 编辑器自动输出的；另一次则是 p 标记打印出来的匹配行。

单独地使用 p 标记没什么用处，通常将 p 标记和 -n 选项结合起来使用，这样就可以只输出被匹配替换过的行了：

```
ed -n 's/root/ROOT/gp' /etc/passwd　　　　# 将 /etc/passwd 中所有的 root 都替换成 ROOT，并输出被修改的行
```

注：可以使用 " = " 命令来打印行号，用法与 p 一样。　


**4）w file ：**将替换的结果写到文件中，不过只保存被修改的行，与 -n + p 的功能类似：

```
sed -n 's/root/ROOT/g w change.txt' /etc/passwd 　　　　# 将 /etc/passwd 中所有的 root 都替换成 ROOT，并将被修改的行保存到文件 change.txt 中去
```

### **三、使用行寻址对特定行进行编辑**

默认情况下，sed 编辑器会对文件中的所有行进行编辑。当然，也可以只指定特定的某些行号，或者行范围来进行流编辑，这需要用到行寻址。所指定的行地址放在编辑命令之前：

```
[address] commands
```

**3.1 使用数字方式进行行寻址**

sed 编辑器将文本流中的每一行都进行编号，第一行的编号为 1 ，后面的按顺序分配行号。通过指定特定的行号，可以选择编辑特定的行。举几个例子：

```
sed '3 s/bin/BIN/g' /etc/passwd　　　　# 将第3行中所有的 bin 替换成 BIN

sed '2,5 s/bin/BIN/g' /etc/passwd　　 # 将第2到5行中所有的 bin 替换成 BIN

sed '10,$ s/bin/BIN/g' /etc/passwd　　# 将第10行到最后一行中所有的 bin 替换成 BIN
```

注：行寻址不止对替换命令有效，对其他命令也都是有效的，后面也会用到。

**3.2 使用文本模式过滤器过滤行**

sed 编辑器允许指定文本模式来过滤出命令要作用的行，格式如下：

```
/pattern/command
```

必须使用斜杠符 " / " 将要指定的文本模式 pattern 包含起来。sed 编辑器会寻找匹配文本模式的行，然后对这些行执行编辑命令：

```
sed -n '/root/s/bin/BIN/p' /etc/passwd    # 寻找包含有字符串 root 的行，并将匹配行的 bin 替换为 BIN
```

与数字寻址一样，也可以使用文本过滤区间来过滤行：

```
sed '/pattern1/,/pattern2/ edit_command' file
```

这行命令会在文件 file 中先寻找匹配 pattern1 的行，然后从该行开始，执行编辑命令，直到找到匹配 pattern2  的行。但是需要注意的是，使用文本区间过滤文本时，只要匹配到了开始模式（pattern1），编辑命令就会开始执行，直到匹配到结束模式（pattern2），这会导致一种情况：一个文本中，先匹配到了一对 pattern1、pattern2，对该文本区间中的文本执行了编辑命令；然后，在 pattern2 之后又匹配到了 pattern1，这时就会再次开始执行编辑命令，因此，在使用文本区间过滤时要格外小心。举个例子：

```
sed -n '/root/,/nologin/ s/bin/BIN/p' /etc/passwd
```

这行命令对 /etc/passwd 进行了两次文本区间匹配，结果如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/zYdZKiaLibic64Cp1r6uVIMfGwZPGw3zuH9X7X6poBGUgoxFUuBjwnRrV5DdPQEvPEZBhdaejXicKJdNJXKMW7geVA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### **四、使用 sed 命令删除行**

sed 编辑器使用 d 命令来删除文本流中的特定行。使用 d 命令时，一般需要带上位寻址，以删除指定的行，否则默认会删除所有文本行：

```
sed '/root/d' /etc/passwd　  # 删除匹配 root 的行

sed '2,$d' /etc/passwd　　　　# 删除第2到最后一行
```

### **五、使用 sed 命令插入和附加文本**

sed 编辑器使用 i 命令来向数据流中插入文本行，使用 a 命令来向数据流中附加文本行。其中：i 命令会在指定行前增加一个新行；a 命令会在指定行后增加一个新行。

需要注意的是，这两个命令都不能在单个命令行上使用（即不是用来在一行中插入或附加一段文本的），只能指定插入还是附加到另一行。命令格式如下：

```
sed '[address][i | a]\newline' file
```

newline 中的文本即为将要插入或附加在一行前面或后面的文本。常常使用这两个命令结合行寻址在特定的行前面或后面增加一个新行。举个例子：

```
sed 'i\Insert a line behind every line' /etc/passwd　　　　　　# 向数据流的每一行前面增加一个新行，新行的内容为 \ 后面的内容

sed '1i\Insert a line behind the first line' /etc/passwd　　　# 在数据流的第一行前面增加一个新行

sed '3a\Append a line after the third line' /etc/passwd      # 在数据流的第三行后面增加一个新行
　　　　
sed '$a\Append a line in the last line' /etc/passwd　　　　　　# 在数据流的最后一行后面增加一个新行
```

### **六、使用 sed 命令修改行**

使用命令 c 可以将数据流中的整行文本修改为新的行，与插入、附加操作一样，这要求在 sed 命令中指定新的行，格式如下：

```
sed '[address][c]\newtext' file
```

newtext 中的文本为匹配行将要被修改成的文本。

```
sed '3 c\New text' /etc/passwd　　　　　# 将数据流中第三行的内容修改为 \ 后面的内容

sed '/root/ c\New text' /etc/passwd　　# 将匹配到 root 的行的内容修改为 \ 后面的内容

sed '2,4c\New text' /etc/passwd　　　　 # 将第2到4行的内容修改为 \ 后面的内容，但是不是逐行修改，而是会将这之间的 3 行用一行文本来替代
```

注意这里对地址区间使用 c 命令进行修改时，不会逐行修改，而是会将整个区间用一行修改文本替代。 

### **七、使用 sed 命令逐字符转换**

使用 y 参数可以按要求对文本进行逐字符转换。格式如下：

```
[address]y/inchars/outchars/
```

转换命令会对 inchars 和 outchars 的值进行一对一的映射。inchars 中的第一个字符会被转换成 outchars 中的第一个字符；inchars 中的第二个字符会被转换成 outchars 中的第二个字符；... 直到处理完一行。如果 inchars 和 outchars 的长度不同，则 sed 编辑器会产生一个错误消息。举个例子：

```
echo abcdefggfedcba | sed 'y/acg/ACG/'
```

输出结果为 AbCdefGGfedCbA。

### **八、使用 sed 命令处理文件**

**8.1 向文件中写入数据**

前面已经提到过，可以使用 w 命令向文件写入行。格式如下：

```
[address]w filename
```

举个例子：

```
sed '1,2w test.txt' /etc/passwd
```
该语句将数据流的第 1、2 行写入文件 test.txt 中去。

**8.2 从文件中读取数据**

可以使用 r 命令来将一个文本中的数据插入到数据流中去，与普通的插入命令 i 类似，这也是对行进行操作的，命令格式如下：

```
[address]r filename
```

filename 为要插入的文件。r 命令常结合行寻址使用，以将文本插入到指定的行后面。举个例子：

```
sed '3 r test.txt' /etc/passwd
```
这句话将文件 test.txt 中的内容插入到数据流第三行后面去。