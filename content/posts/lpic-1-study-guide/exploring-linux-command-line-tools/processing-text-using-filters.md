---
title: "LPIC-1 Study Guide: Processing Text Using Filters"
date: 2024-07-03T06:00:20+06:00
hero: /images/posts/lpic-1/processing-text-using-filters.jpg
description: "LPIC-1 Study Guide: Processing Text Using Filters"
menu:
  sidebar:
    name: "Processing Text Using Filters"
    identifier: processing-text-using-filters
    parent: exploring-linux-command-line-tools
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

Upcomming.......
