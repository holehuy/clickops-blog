---
title: "LPIC-1 Study Guide: Processing Text Using Filters"
date: 2024-07-03T06:00:20+06:00
hero: /images/posts/lpic-1/processing-text-using-filters.jpg
description: "LPIC-1 Study Guide: Processing Text Using Filters"
menu:
  sidebar:
    name: "Processing Text Using Filters"
    identifier: processing-text-using-filters
    parent: linux
    weight: 3
---

Dưới giao diện dòng lệnh Linux, bạn thường cần xem các tệp tin hoặc một phần của chúng. Ngoài ra, bạn có thể cần sử dụng các công cụ cho phép bạn thu thập các đoạn dữ liệu hoặc thống kê tệp tin để khắc phục sự cố hoặc phân tích. Các tiện ích trong phần này có thể giúp bạn thực hiện tất cả các hoạt động này.

## File-Combining Commands
Việc kết hợp các tập tin văn bản ngắn để xem trên màn hình và so sánh chúng là rất hữu ích. Các lệnh kết hợp tập tin (file-combining commands) được nói trong bài này sẽ làm chính xác điều đó.

Tiện ích cơ bản để xem toàn bộ các tập tin văn bản là `concatenate` command. Mặc dù mục đích chính của công cụ này là để kết hợp các tập tin văn bản và hiển thị chúng, nhưng nó thường được sử dụng chỉ để hiển thị một tệp tin văn bản nhỏ. Để xem một tệp tin văn bản nhỏ, hãy sử dụng `cat` command với cú pháp cơ bản như sau:

*cat [OPTION]... [FILE]...*

`cat` command rất đơn giản để sử dụng. Bạn chỉ cần nhập lệnh và theo sau là bất kỳ tệp tin văn bản nào bạn muốn đọc, như được hiển thị trong Danh sách 1.27.

**Listing 1.27:** Sử dụng `cat` command để hiển thị một file
```
$ cat number.txt
42
2A
52
0010 1010 *
$
```

`cat` command hiển thị toàn bộ nội dung của tệp tin văn bản lên màn hình. Khi bạn nhận lại được dấu nhắc (prompt) của mình, bạn sẽ biết rằng dòng ngay trên dấu nhắc là dòng cuối cùng của tệp tin.

{{< alert type="info" >}}
Có một bản sao mới tiện dụng của lệnh `cat` đó là `bat`. Nhà phát triển của nó gọi nó là “cat with wings” (con mèo có cánh), vì tiện ích `bat` có nhiều tính năng bổ sung. Bạn có thể đọc về các tính năng của nó tại [github.com/sharkdp/bat](https://github.com/sharkdp/bat).
{{< /alert >}}

Trong Listing 1.28 là một ví dụ về ghép 2 tệp lại với nhau để hiển thị nội dung văn bản của chúng lần lượt bằng cách sử dụng lệnh `cat`.

**Listing 1.28:** Sử dụng `cat` command để nối 2 tệp với nhau
```
$ cat numbers.txt random.txt 42
2A
52
0010 1010
*
42
Flat Land Schrodinger's Cat 0010 1010
0000 0010 
$
```

Cả hai tệp được hiển thị trong Listing 1.28 đều có số 42 ở dòng đầu tiên. Đây là cách duy nhất bạn có thể biết nơi một tệp kết thúc và tệp kia bắt đầu, vì tiện ích `cat` không biểu thị phần đầu hoặc phần cuối của tệp trong đầu ra của nó. Còn có nhiều tuỳ chọn hữu ích của tiện ích `cat` mà chúng ta chưa khám phá.

Bảng 1.16 có một số options được sử dụng phổ biến

**TABLE 1.16:** Một số options hay sử dụng của `cat`
| Short | Keystroke(s)         | Descriptions |
| :---- | :-------------------        | :------------------------------------------------- |
| -A    | --show-all           | Tương đương với việc sử dụng tuỳ chọn kết hợp -vET. |
| -E    | --show-ends          | hiển thị ký tự $ khi gặp một ký tự xuống dòng (newline linefeed). |
| -n    | --number             | Đánh số tất cả các dòng tệp văn bản và hiển thị số đó ở đầu ra. |
| -s    | --squeeze-blank      | Không hiển thị các dòng tệp văn bản trống lặp đi lặp lại.. |
| -T    | --show-tabs          | Hiển thị ^I khi gặp ký tự tab. |
| -v    | --show-nonprinting         | Hiển thị các ký tự không in được khi gặp phải bằng cách sử dụng ký hiệu ^ và/hoặc M-. |


Có thể hiển thị các ký tự không in được bằng lệnh `cat` rất tiện lợi. Nếu bạn có một tệp văn bản đang gây ra một số vấn đề kỳ lạ khi xử lý nó, bạn có thể nhanh chóng xem liệu có bất kỳ ký tự không in được nào được nhúng hay không. Trong Listing 1.29 một ví dụ được hiển thị về phương pháp này.

**Listing 1.29:** Sử dụng `cat` command để hiển thị các kí tự không in được
```
$ cat bell.txt

$ cat -v bell.txt 
^G
$
```

Trong Listing 1.29, lệnh `cat` đầu tiên hiển thị tệp và dường như nó chỉ chứa một dòng trống. Tuy nhiên, khi tùy chọn `-v` được sử dụng, bạn có thể thấy rằng một ký tự không thể in được tồn tại trong tệp. `^G` nằm trong ký hiệu dấu mũ và cho biết ký tự Unicode không in được BEL được nhúng trong tệp. Ký tự này gây ra âm thanh chuông khi tập tin được hiển thị.

{{< alert type="info" >}}
Có nhiều biến thể thú vị của `cat` command như `bcat`, `xzcat` và `zcat`. Những tiện ích này được sử dụng để hiển thị nội dung của các tệp nén. (Nén tập tin (File compression) được đề cập trong Chapter 4.)
{{< /alert >}}

Nếu bạn muốn hiển thị hai tệp cạnh nhau và không quan tâm đến việc đầu ra cẩu thả, đẹp xấu thế nào, bạn có thể sử dụng `paste` command. Cũng giống như keo dán ở trường, nó sẽ dán chúng lại với nhau nhưng kết quả không nhất thiết phải đẹp. Một ví dụ về cách sử dụng `paste` command được hiển thị trong Listing 1.30.

**Listing 1.30** Sử dụng `paste` command để nối các tệp cạnh nhau
```
$ cat random.txt 
42
Flat Land 
Schrodinger's Cat 
0010 1010
0000 0010
$
$ cat numbers.txt 42
2A
52
0010 1010
*
$
$ paste random.txt numbers.txt 
42    42
Flat    Land 2A 
Schrodinger's Cat     52 
0010 1010     0010 1010
0000 0010     *
$
```

{{< alert type="info" >}}
Nếu bạn cần cách hiển thị đẹp hơn cách của `paste` command thì cân nhắc sử dụng `pr` command. Nếu các tệp chia sẻ cùng một dữ liệu trong một field cụ thể, bạn cũng có thể sử dụng `join` command.
{{< /alert >}}

## File-Transforming Commands

Việc xem và hiển thị dữ liệu theo nhiều cách khác nhau không chỉ hữu ích trong việc khắc phục sự cố mà còn trong công việc testing. Trong phần này, chúng ta sẽ xem xét một số file-transforming command (lệnh chuyển đổi file).

### Uncovering with `od`

Thỉnh thoảng bạn có thể cần thực hiện một số công việc như là một thám tử với các tập tin của mình. Những tình huống như thế này có thể bao gồm việc cố gắng xem một tệp đồ hoạ hoặc khắc phục sự cố tệp văn bản đã bị một chương trình sửa đổi. Tiện ích `od` command có thể là lựa chọn trong trường hợp này vì nó cho phép bạn hiển thị nội dung của tệp theo hệ bát phân (base 8), hệ thập lục phân (base 16), hệ thập phân (base 10) và ASCII. Cú pháp cơ bản của nó như sau:

*od [OPTION]... [FILE]...*

Theo mặc định, `od` hiển thị văn bản của tệp ở dạng bát phân. Một ví dụ được hiển thị trong Listing 1.31.

**Listing 1.31:** Sử dụng `od` command để hiển thị văn bản của tệp ở dạng bát phân
```
$ cat fourtytwo.txt 
42
fourty two
quarante deux
zweiundvierzig
forti to
$
$ od fourtytwo.txt
0000000 031064 063012 072557 072162 020171 073564 005157 072561 
0000020 071141 067141 062564 062040 072545 005170 073572 064545 
0000040 067165 073144 062551 075162 063551 063012 071157 064564 
0000060 072040 005157
0000064
```

Cột đầu tiên trong đầu ra của lệnh `od` là một số chỉ mục cho mỗi dòng hiển thị. Ví dụ, trong Listing 1.31, dòng bắt đầu bằng `0000040` cho biết rằng dòng thứ ba bắt đầu từ byte octal 40 (thập phân 32) trong tệp.

Bạn có thể sử dụng các tùy chọn khác để cải thiện "khả năng đọc" của hiển thị lệnh od hoặc để xem các đầu ra khác nhau (xem các trang man để biết thêm các tùy chọn tiện ích od và cách trình bày của chúng). Listing 1.32 là một ví dụ về việc sử dụng các tùy chọn -cb để hiển thị các ký tự trong tệp, cùng với vị trí byte octal của mỗi ký tự trong tệp văn bản.

**Listing 1.32** Sử dung `od -cd` command để hiển thị thông tin bổ sung
```
$ od -cb fourtytwo.txt
0000000    4   2  \n   f   o   u   r   t   y       t   w   o  \n   q   u
          064 062 012 146 157 165 162 164 171 040 164 167 157 012 161 165
0000020    a   r   a   n   t   e       d   e   u   x  \n   z   w   e   i
          141 162 141 156 164 145 040 144 145 165 170 012 172 167 145 151
0000040    u   n   d   v   i   e   r   z   i   g  \n   f   o   r   t   i
          165 156 144 166 151 145 162 172 151 147 012 146 157 162 164 151
0000060        t   o  \n
          040 164 157 012
0000064
```

{{< alert type="info" >}}
Thêm tùy chọn -u vào lệnh od. Tùy chọn này sẽ cho phép hiển thị tất cả các ký tự Unicode, ngoài tập hợp con ký tự ASCII hiện có sẵn.
{{< /alert >}}

### Separating with `split`

Một command hay để sử dụng là `split`. Tiện ích này cho phép bạn chia một tệp lớn thành các phần nhỏ hơn, rất tiện lợi khi bạn muốn tạo nhanh một tệp văn bản nhỏ hơn cho mục đích testing. Cú pháp cơ bản của `split` commmand như sau:

*split [OPTION]... [INPUT [PREFIX]]*

Bạn có thể chia nhỏ tệp theo kích thước, theo byte, theo dòng,... Tệp gốc sẽ không bị thay đổi, và các tệp mới bổ sung sẽ được tạo ra tuỳ thuộc vào option được chọn khi thao tác lệnh. Trong Listing 1.33, một ví dụ cho thấy việc sử dụng tùy chọn chia một tệp theo số dòng của nó.

**Listing 1.33:** Sử dụng lệnh `split -l` để chia tệp theo số dòng
```
$ cat fourtytwo.txt 
42
fourty two
quarante deux
zweiundvierzig
forti to
$
$ split -l 3 fourtytwo.txt split42
$
$ ls split42*
split42aa split42ab
$
$ cat split42aa
42
fourty two
quarante deux
$
$ cat split42ab
zweiundvierzig
forti to
$
```

Lưu ý rằng để chia tệp theo số dòng của nó, bạn cần sử dụng tùy chọn -l (chữ thường của L) và cung cấp số dòng tệp văn bản để cố gắng đưa vào mỗi tệp mới. Trong ví dụ trên, tệp gốc có năm dòng văn bản, do đó, một tệp mới (split42aa) có ba dòng đầu tiên của tệp gốc và tệp mới thứ hai (split42ab) có hai dòng cuối cùng. Cũng chú ý rằng mặc dù bạn chỉ định tên của các tệp mới (PREFIX), `split` command sẽ gắn các ký tự bổ sung, chẳng hạn như aa và ab, vào tên, như trong Listing 1.33.

{{< alert type="info" >}}
`tr` command là một lệnh chuyển đổi tập tin tiện dụng khác. Nó được đề cập ở phần sau của chương này.
{{< /alert >}}

## File-Formating Commands

Thông thường để hiển thị dữ liệu trong tệp văn bản, chúng ta sẽ cần định dạng lại dữ liệu theo một cách nào đó. Có một số tiện ích đơn giản để có thể định dạng dữ liệu.

### Organizing with `sort`

Đây là tiện ích dùng để sắp xếp dữ liệu của tệp. Hãy nhớ rằng nó không làm thay đổi bản gốc tài liệu; chỉ có đầu ra được sắp xếp. Cú pháp cơ bản của lệnh này như sau:

*sort [OPTION]... [FILE]...*

Nếu bạn muốn sắp xếp nội dung của tệp theo thứ tự sắp xếp tiêu chuẩn của hệ thống, hãy nhập lệnh `sort` theo sau là tên tệp bạn muốn sắp xếp. Listing 1.34 cho thấy một ví dụ về điều này.

**Listing 1.34:** Sử dụng `sort` command
```
$ cat alphabet.txt Alpha
Tango
Bravo
Echo
Foxtrot
$
$ sort alphabet.txt Alpha
Bravo
Echo
Foxtrot
Tango
$
```

Nếu tệp chứa số, dữ liệu có thể không theo thứ tự bạn mong muốn khi sử dụng tiện ích `sort`. Để có được thứ tự số thích hợp, hãy thêm tùy chọn `-n` vào lệnh, như trong Listing 1.35.

**Listing 1.35:** Sử dụng `sort -n` command
```
$ sort counts.txt 
105
37
42
54
8
$ sort -n counts.txt 
8
37
42
54
105
$
```

Trong Listing 1.35, lưu ý rằng lần thử đầu tiên để sắp xếp thứ tự số của tệp, sử dụng lệnh `sort` không có tùy chọn, sẽ mang lại kết quả không chính xác. Tuy nhiên, lần thử thứ hai sử dụng lệnh `sort -n`, lệnh này sắp xếp tập tin một cách chính xác theo thứ tự.

{{< alert type="info" >}}
Nếu bạn muốn lưu dữ liệu đã sắp xếp từ output của `sort` command thành một tệp, tất cả những gì bạn cần làm là thêm option `-o`. Ví dụ `sort -o newfile.txt alphabet.txt` sẽ sắp xếp tệp alphabet.txt và lưu trữ nội dung đã sắp xếp vào newfile.txt.
{{< /alert >}}

### Numbering with `nl`

Một lệnh định dạng khác đó là `nl` (number line) dùng để đánh số cho dòng trong tệp văn bản. Thậm chí nó còn cho phép chúng ta thực hiện các biểu thức chính quy (được đề cập ở phần sau trong chương này) để chỉ định dòng nào cần đánh số. Cú pháp của `nl` command khá đơn giản:

*nl [OPTION]... [FILE]...*

Nếu bạn không sử dụng bất kỳ tùy chọn nào với tiện ích nl, nó sẽ chỉ đánh số ở dòng không bị trống. Một ví dụ được hiển thị trong Listing 1.36.

**Listing 1.36:** Sử dụng `nl` command để thêm số vào dòng không trống
```
$ nl ContainsBlankLines.txt 
    1 Alpha
    2 Tango

    3 Bravo
    4 Echo


    5 Foxtrot 
$
```

Nếu bạn muốn đánh số tất cả các dòng của tệp, kể cả những dòng trống, thì bạn cần sử dụng option `-ba`. Một ví dụ được hiển thị trong Listing 1.37.

**Listing 1.37:** Sử dụng `nl -ba` command để đánh số tất cả các dòng tệp văn bản
```
$ nl -ba ContainsBlankLines.txt
    1 Alpha
    2 Tango
    3
    4 Bravo
    5 Echo
    6
    7
    8 Foxtrot 
$
```

{{< alert type="info" >}}
`sed` command cũng cho phép bạn định dạng tệp văn bản. Tuy nhiên, vì tiện ích này sử dụng các biểu thức chính quy nên nó sẽ được trình bày sau phần biểu thức chính quy trong chương này.
{{< /alert >}}

## File-Viewing Commands

Khi thao tác bằng command-line, việc xem tệp là một hoạt động hàng ngày. Đối với một tệp văn bản ngắn, sử dụng `cat` command là đủ. Tuy nhiên, khi bạn cần xem một tệp lớn hoặc một phần của tệp đó, có sẵn các lệnh khác hoạt động tốt hơn lệnh `cat` và chúng sẽ được đề cập trong phần này.

### Using `more` or `less`

Một cách để đọc qua một tệp văn bản lớn là sử dụng `paper`. Một tiện ích gọi là pager cho phép bạn xem từng trang văn bản và di chuyển qua văn bản theo tốc độ của riêng bạn. Hai tiện ích pages được sử dụng phổ biến nhất là `more` và `less`

*more [OPTION] FILE [...]*

Với `more` bạn có thể di chuyển tiếp qua tệp văn bản bằng cách nhấn phím cách (xuống một trang), hoặc phím Enter (xuống một dòng) tuy nhiên lại không di chuyển lùi qua tập tin được. Khi bạn muốn thoát khỏi `more` pager, bạn phải nhấn phím `Q`.

Hình 1.4 cho thấy việc sử dụng `less` pager trên tệp */etc/nsswitch.conf*.

FIGURE 1.4: Sử dụng `less` text pager

{{< img src="/assets/images/posts/lpic-1/figure1_4.png" align="center" title="using less text pager" >}}

Mặc dù tương tự như `more` tuy nhiên `less` lại cho phép bạn di chuyển lùi. Dẫn đến `less` có nhiều khả năng hơn `more`. Chính vì vậy mà đã có mô tả nổi tiếng về pager này là **"less is more"** =))).

`less` tải tệp nhanh hơn vì nó không đọc toàn bộ tệp trước khi hiển thị. Bạn có thể sử dụng phím mũi tên lên hoặc xuống để duyệt qua tập tin, cũng như phím cách để di chuyển tới một trang và tổ hợp phím `Ctrl + V` để di chuyển ngược trở lại một trang. Có thể tìm kiếm một từ cụ thể bằng cách nhấn nút hỏi chấm `?` sau đó gõ từ bạn muốn tìm và nhấn Enter để tìm kiếm ngược trở về phía trước. Hoặc thay thế `?` bằng `/` để tìm kiếm về phía sau. Cũng giống như `more`, bạn cần dùng phím `Q` để thoát.

### Looking at files with `head`

Một công cụ hữu ích khác để hiển thị các phần của tệp văn bản là tiện ích `head`. Cú pháp như sau:

*head [OPTION]... [FILE]...*

Theo mặc định, lệnh `head` hiển thị 10 dòng đầu tiên của tệp văn bản. Ví dụ ở Listing 1.38.

**Listing 1.38:** Sử dụng `head` command
```

$ head /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
bin:x:1:1:bin:/bin:/sbin/nologin 
daemon:x:2:2:daemon:/sbin:/sbin/nologin 
adm:x:3:4:adm:/var/adm:/sbin/nologin 
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin 
sync:x:5:0:sync:/sbin:/bin/sync 
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown 
halt:x:7:0:halt:/sbin:/sbin/halt 
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin 
operator:x:11:0:operator:/root:/sbin/nologin
$
```

Để hiển thị số dòng theo ý muốn chúng ta cần option `-n` để ghi đè hành vi mặc định (10 dòng). Cú pháp `head -n` theo sau là số dòng muốn hiển thị như ví dụ ở Listing 1.39.

Listing 1.39: Sử dụng lệnh `head` để hiển thị số dòng ít hơn
```
$ head -n 2 /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
bin:x:1:1:bin:/bin:/sbin/nologin 
$
$ head -2 /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
bin:x:1:1:bin:/bin:/sbin/nologin 
$
```

Lưu ý trong Listing 1.38, option `-n 2` là đối số được sử dụng với lệnh `head` chỉ hiển thị hai dòng đầu tiên của tệp. Tuy nhiên, lệnh thứ hai loại bỏ phần `n` chỉ còn số 2 và lệnh này vẫn sẽ hoạt động giống như lệnh đầu tiên.

### Viewing Files with `tail`

Nếu bạn muốn hiển thị dòng cuối cùng của tệp thay vì dòng đầu tiên, hãy sử dụng tiện ích `tail`. Cú pháp của `tail` cũng như lệnh `head` như sau:

*tail [OPTION]... [FILE]...*

Theo mặc định, lệnh `tail` sẽ hiển thị 10 dòng văn bản cuối cùng của tệp. Tuy nhiên, bạn có thể ghi đè hành vi đó bằng cách sử dụng khóa chuyển `-n` (hoặc `--lines=`) bằng một đối số. Đối số cho biết có bao nhiêu dòng từ cuối tập tin cần hiển thị. Nếu bạn thêm dấu cộng (+) vào trước đối số, tiện ích `tail` sẽ bắt đầu hiển thị các dòng văn bản của tệp bắt đầu từ số dòng được chỉ định cho đến cuối tệp. Có ba ví dụ về việc sử dụng đuôi theo những cách này trong Listing 1.40.

**Listing 1.40:** Sử dụng `tail` command
```
$ tail /etc/passwd
saslauth:x:992:76:Saslauthd user:/run/saslauthd:/sbin/nologin 
pulse:x:171:171:PulseAudio System Daemon:/var/run/pulse:/sbin/nologin 
gdm:x:42:42::/var/lib/gdm:/sbin/nologin 
setroubleshoot:x:991:985::/var/lib/setroubleshoot:/sbin/nologin 
rpcuser:x:29:29:RPC Service User:/var/lib/nfs:/sbin/nologin 
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin 
sssd:x:990:984:User for sssd:/:/sbin/nologin 
gnome-initial-setup:x:989:983::/run/gnome-initial-setup/:/sbin/nologin
tcpdump:x:72:72::/:/sbin/nologin
avahi:x:70:70:Avahi mDNS/DNS-SD Stack:/var/run/avahi-daemon:/sbin/nologin 
$
$ tail -n 2 /etc/passwd
tcpdump:x:72:72::/:/sbin/nologin
avahi:x:70:70:Avahi mDNS/DNS-SD Stack:/var/run/avahi-daemon:/sbin/nologin 
$
$ tail -n +42 /etc/passwd gnome-initial-setup:x:989:983::/run/gnome-initial-setup/:/sbin/nologin 
tcpdump:x:72:72::/:/sbin/nologin
avahi:x:70:70:Avahi mDNS/DNS-SD Stack:/var/run/avahi-daemon:/sbin/nologin 
$
```

Một trong những tính năng hữu ích nhất của tiện ích `tail` là khả năng theo dõi các tệp nhật ký. Để sử dụng tính năng này, bạn có thể sử dụng tùy chọn `-f` (hoặc `--follow`) với lệnh `tail` và cung cấp tên tệp nhật ký làm đối số cho lệnh. Bạn sẽ thấy một vài mục nhập nhật ký gần đây ngay lập tức. Khi bạn tiếp tục theo dõi, các thông điệp bổ sung sẽ hiển thị khi chúng được thêm vào tệp nhật ký.

Để kết thúc phiên giám sát của bạn bằng `tail`, bạn phải sử dụng tổ hợp phím `Ctrl+C`. Một ví dụ về xem tệp nhật ký bằng tiện ích `tail` được hiển thị trong Listing 1.41.

**Listing 1.41:** Watching a log file with the tail command
```
$ sudo tail -f /var/log/auth.log
[sudo] password for Christine:
Aug 27 10:15:14 Ubuntu1804 sshd[15662]: Accepted password [...] 
Aug 27 10:15:14 Ubuntu1804 sshd[15662]: pam_unix(sshd:sess[...] 
Aug 27 10:15:14 Ubuntu1804 systemd-logind[588]: New sessio[...] 
Aug 27 10:15:50 Ubuntu1804 sudo: Christine : TTY=pts/1 ; P[...] 
Aug 27 10:15:50 Ubuntu1804 sudo: pam_unix(sudo:session): s[...] 
Aug 27 10:16:21 Ubuntu1804 login[10703]: pam_unix(login:se[...] 
Aug 27 10:16:21 Ubuntu1804 systemd-logind[588]: Removed se[...] 
^C
$
```

## File-Summarizing Commands

### Counting with `wc`

Tiện ích `wc` (word count) là cách dễ nhất và phổ biến nhất để xác định số lượng (dòng, từ và byte) trong một tệp văn bản.

Cú pháp cơ bản của lệnh `wc` là:

*wc [OPTION]... [FILE]...*

Khi bạn chạy lệnh `wc` mà không có bất kỳ tùy chọn nào và cung cấp tên tệp làm đối số, `wc` sẽ hiển thị các thông tin sau của tệp tin:

- Số dòng
- Số từ
- Số byte

Đây là một ví dụ (Listing 1.42).

**Listing 1.42:**  Sử dụng `wc` command
```
$ wc random.txt
5 9 52 random.txt
$
```

Có một số tùy chọn hữu ích và thường được sử dụng cho lệnh `wc`  được liệt kê trong Bảng 1.7.

**TABLE 1.7:** Các options phổ biến của `wc` command

| Short | Long    | Description |
| :---- | :------ | :------------------------------------------------------------------ |
| -c | --bytes | Hiển thị số byte của tập tin. |
| -L | --max-line-length | Hiển thị số byte của dòng dài nhất của tập tin. |
| -l | --lines | Hiển thị số dòng của tập tin.|
| -m | --chars | Hiển thị số ký tự của tập tin |
| -w | --words | Hiển thị số từ của tập tin |

Một tùy chọn của lệnh `wc` để xử lý các tệp cấu hình (configuration file) là tùy chọn `-L`. Thông thường, độ dài dòng cho một tệp cấu hình sẽ dưới 150 byte, mặc dù vẫn có những ngoại lệ. Do đó, nếu bạn vừa chỉnh sửa một tệp cấu hình và dịch vụ đó không còn hoạt động nữa, hãy kiểm tra độ dài dòng dài nhất của tệp. Độ dài dòng dài hơn bình thường có thể cho thấy bạn đã vô tình trộn hai dòng cấu hình lại với nhau. Dưới đây là một ví dụ (Listing 1.43):

**Listing 1.43:** Sử dụng `wc` command để kiểm tra chiều dài dòng
```
$ wc -L /etc/nsswitch.conf 
72 /etc/nsswitch.conf
$
```

### Pulling Out Portions with `cut`

Để sàng lọc dữ liệu trong một file văn bản lớn và trích xuất nhanh chóng các phần dữ liệu nhỏ. `cut` là một công cụ hữu ích để thực hiện việc này. Nó sẽ cho phép bạn xem các trường cụ thể trong bản ghi của tệp. Cú pháp cơ bản của lệnh như sau:

*cut OPTION... [FILE]...*

Trước khi chúng ta đi sâu vào sử dụng lệnh này, có một số điều cơ bản cần hiểu về lệnh `cut`. Cụ thể như sau:

**Text File Records** Một Text File Records là một file đơn lẻ kết thúc bằng một **newline linefeed** (là ký tự ASCII LF). Bạn có thể kiểm tra tệp của mình có sử dụng có sử dụng end-of-line character này không bằng lệnh `cat -E`, nó sẽ hiển thị tất cả **newline linefeed** thành ký tự $. Nếu bản ghi tệp văn bản của bạn kết thúc bằng ký tự ASCII NUL, bạn cũng có thể sử dụng lệnh `cut` trên chúng, nhưng bạn phải sử dụng tùy chọn `-z`.

**Text File Record Delimiter** Để sử dụng một số tùy chọn lệnh của `cut` một cách đúng đắn, các field phải tồn tại trong mỗi bản ghi tệp văn bản. Những field này không phải là các field kiểu cơ sở dữ liệu, mà là các dữ liệu được phân cách bởi một số dấu phân cách. Dấu phân cách (**Delimiter**) là một hoặc nhiều ký tự tạo ra một ranh giới giữa các mục dữ liệu khác nhau trong một bản ghi. 1 dấu cách cũng có thể được xem là dấu phân cách. Tệp mật khẩu */etc/passwd* sử dụng dấu hai chấm (:) để phân cách các mục dữ liệu trong một bản ghi.

**Text File Changes** Khác với tên của nó, lệnh `cut` không thay đổi bất kĩ dữ liệu nào trong văn bản, nó chỉ sao chép dữ liệu bạn muốn xem và hiển thị nó cho bạn. Bạn có thể yên tâm rằng không có thay đổi nào với tệp của bạn.

Lệnh `cut` có nhiều tuỳ chọn mà chúng ta sẽ dùng thường xuyên. Các tuỳ chọn này được liệt kê ở Bảng 1.8.

**TABLE 1.8:** Các tuỳ chọn phổ biến của `cut` command
| Short            | Long                      | Description                                                         |
| :--------------  | :------------------------ | :------------------------------------------------------------------ |
| -c *nlist*       | --characters *nlist*      | Chỉ hiển thị các ký tự trong *nlist* (e.g., 1-5). |
| -b *blist*       | --bytes *blist*           | Hiển thị các bytes cụ thể trong *blist* (e.g, 1-2). |
| -d *d*           | --delimiter *d*           | Chỉ định dấu phân cách của các field của bản ghi là *d*. Điều này overwrite dấu phân cách mặc định là Tab. Đặt *d* trong dấu nhảy kép để tránh kết quả không mong muốn |
| -f *flist*       | --fields *flist*          | Chỉ hiển thị các field trong *flist* (e.g., 1,3) |
| -s               | --only-delimited          | Chỉ hiển thị các bản ghi có chứa dấu phân cách được chỉ định. |
| -z               | --zero-terminated         | Chỉ định ký tự cuối dòng của bản ghi là ký tự ASCII NUL. |

**Listing 1.44:** Sử dụng `cut` command
```
$ head -2 /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
bin:x:1:1:bin:/bin:/sbin/nologin 
$
$ cut -d ":" -f 1,7 /etc/passwd 
root:/bin/bash 
bin:/sbin/nologin
[...]
$
``` 

Trong Listing 1.44, lệnh `head` hiển thị 2 dòng đầu tiên của tệp passwd. Tệp văn bản này sử dụng dấu hai chấm (:) để phân cách các trường trong mỗi bản ghi. Việc sử dụng lệnh `cut` lần đầu tiên sẽ chỉ định dấu phân cách là dấu hai chấm bằng tùy chọn `-d`. Dấu hai chấm đang được để trong dấu nháy kép đề phòng kết quả không mong muốn. Tuỳ chọn `-f` chỉ định rằng chỉ hiển thị các field 1 (tên người dùng) và 7 (shell) 

### Discovering Repeated Lines with uniq

Một cách nhanh chóng để tìm các dòng lặp lại trong tệp văn bản là sử dụng tiện ích `uniq`. Chỉ cần gõ `uniq` và theo sau là tên tệp có nội dung bạn muốn kiểm tra.

Tiện ích `uniq` sẽ chỉ tìm thấy các dòng văn bản lặp lại nếu chúng nằm ngay sau nhau. Khi được gọi mà không có bất kỳ tùy chọn nào, lệnh sẽ chỉ hiển thị các dòng duy nhất (không lặp lại). Một ví dụ về cách sử dụng lệnh này được hiển thị trong Listing 1.45.

**Listing 1.45:** Sử dụng `uniq` command
```
$ cat NonUniqueLines.txt 
A
C
C
A 
$
$ uniq NonUniqueLines.txt 
A
C
A
$
```

Lưu ý rằng trong đầu ra của lệnh `cat` thực tế có hai tập hợp dòng lặp lại trong tệp này. Một là dòng C và còn lại là dòng A. Vì tiện ích `uniq` chỉ nhận dạng các dòng lặp lại nối tiếp nhau trong một tệp văn bản nên chỉ một trong các dòng văn bản C bị xóa khỏi màn hình. Hai dòng A vẫn được hiển thị.

### Digesting an MD5 Algorithm

Tiện ích `md5sum` dựa trên thuật toán MD5. Ban đầu nó được tạo ra để sử dụng trong mật mã. Nó không còn được sử dụng với các chức năng cho mật mã như vậy do có nhiều lỗ hổng đã biết. Tuy nhiên, nó vẫn rất hữu ích để kiểm tra tính toàn vẹn của tệp. Một ví dụ đơn giản được hiển thị trong Listing 1.46.

**Listing 1.46:** Sử dung `md5sum` để kiểm tra tính toàn vẹn của tập tin
```
$ md5sum fourtytwo.txt 
0ddaa12f06a2b7dcd469ad779b7c2a33 fourtytwo.txt 
$
```

`md5sum` tạo ra giá trị băm 128-bit. Nếu bạn sao chép tệp sang hệ thống khác trên mạng của mình, hãy chạy md5sum trên tệp đã sao chép. Nếu bạn nhận thấy giá trị băm của tệp gốc và tệp sao chép khớp nhau, điều này cho thấy không có lỗi tệp nào xảy ra trong quá trình truyền tệp.


### Securing Hash Algorithms

Thuật toán băm an toàn (SHA) là một nhóm gồm nhiều các hàm băm khác nhau. Mặc dù thường được dùng cho mục đích mã hoá nhưng chúng cũng có thể sử dụng để xác minh tính toàn vẹn của tệp sao khi sao chép hoặc chuyển sang một hệ thống khác. 

Một số tiện ích triển khai các thuật toán này trên hệ thống Linux. Cách nhanh nhất để tìm thấy chúng là thông qua các phương pháp được liệt kê trong Listing 1.47. Một vài bản phân phối sẽ lưu trữ chúng trong thư mục */bin* thay vì */usr/bin*.

**Listing 1.47:** Tên các tiện ích triển khai các thuật toán SHA trên Linux
```
$ ls -1 /usr/bin/sha???sum 
/usr/bin/sha224sum 
/usr/bin/sha256sum 
/usr/bin/sha384sum 
/usr/bin/sha512sum
$
```

**Listing 1.48:** Sử dụng `sha256sum` and `sha512sum` để kiểm tra file
```
$ sha256sum fourtytwo.txt 
0b2b6e2d8eab41e73baf0961ec707ef98978bcd8c7 
74ba8d32d3784aed4d286b fourtytwo.txt
$
$ sha512sum fourtytwo.txt 
ac72599025322643e0e56cff41bb6e22ca4fbb76b1d 7fac1b15a16085edad65ef55bbc733b8b68367723ced 
3b080dbaedb7669197a51b3b6a31db814802e2f31 fourtytwo.txt 
$
```

Lưu ý trong Listing 1.48, các độ dài giá trị băm khác nhau được tạo ra bởi các lệnh khác nhau. Tiện ích `sha512sum` sử dụng thuật toán `SHA-512`, thuật toán tốt nhất để sử dụng cho mục đích bảo mật và thường được sử dụng để băm salted password trong tệp */etc/shadow* trên Linux.

Bạn có thể sử dụng các tiện ích SHA này, giống như **md5sum** được sử dụng trong Listing 1.46, để đảm bảo tính toàn vẹn của tệp khi nó được truyền sang các hệ thống. Bằng cách đó, tệp sẽ tránh bị hỏng cũng như tránh được mọi sửa đổi độc hại đối với tệp.