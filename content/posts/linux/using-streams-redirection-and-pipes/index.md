---
title: "LPIC-1 Study Guide: Using Streams, Redirection, and Pipes"
date: 2024-07-15T06:00:20+06:00
hero: /images/posts/lpic-1/using-streams-redirection-and-pipes.jpg
description: "LPIC-1 Study Guide: Using Streams, Redirection, and Pipes"
menu:
  sidebar:
    name: "Using Streams, Redirection, and Pipes"
    identifier: using-streams-redirection-and-pipes
    parent: linux
    weight: 5
---

Một trong những điều thú vị của command-line đó chính là chúng ta không chỉ có những dòng lệnh đơn giản mà còn thực hiện được những tác vụ phức tạp hơn nhiều. Ví dụ như là xây dựng các command từ các command khác, sử dụng đầu ra của lệnh này làm đầu vào cho lệnh khác,...

Hầu hết các hệ điều hành nói chung và Linux/Unit nói riêng thì có 2 dòng xuất nhập chuẩn (I/O) là **STDIN**, **STDOUT** và **STDERR** mà chức năng tương ứng là dòng nhập chuẩn, dòng xuất chuẩn và dòng lỗi chuẩn. Chúng được gọi là các `open file` và hệ thống gán cho mỗi file này một con số goi là `file descriptor`. STDIN ứng với 0, STDOUT ứng với 1, STDERR ứng với 2. Cụ thể

> standard input -> stdin -> 0
> 
> standard output -> stdout -> 1
> 
> standard error -> stderr -> 2


## Redirecting Input and Output

Khi xử lý và lọc các tệp văn bản, bạn có thể muốn lưu dữ liệu được tạo ra. Ngoài ra, bạn có thể cần kết hợp nhiều bước sàng lọc khác nhau để có được thông tin bạn cần. Chúng ta sẽ đi tìm hiểu cách thực hiện trong phần này.

### Handling Standard Output

Một điều quan trọng chúng ta cần biết đó là Linux xử lý mọi đối tượng như là một tệp. Điều này bao gồm cả quá trình đầu ra, như hiển thị một tệp tin văn bản trên màn hình.  Mỗi đối tượng tệp tin được xác định bằng một `file descriptor` (gọi là bộ mô tả tệp tin) là một số nguyên phân loại các tệp tin của một tiến trình. `file descriptor` xác định đầu ra của một command hoặc một script file là số `1`. Nó cũng được xác định bằng từ viết tắt STDOUT (Standard Output). STDOUT là các dòng xuất chuẩn nói chung.

Trong chế độ command line của hầu hết các hệ điều hành thì "<" dùng cho chuyển hướng nhập và ">" dùng cho chuyển hướng xuất. Vì sao phải chuyển hướng? Vì có nhiều lúc ta muốn kết quả xuất ra màn hình được lưu lại vào một file và dữ liệu nhập vào thay vì từ bàn phím thì lại từ một file.

Theo mặc định, STDOUT định hướng đầu ra đến terminal hiện tại của bạn. Terminal hiện tại của quá trình của bạn được biểu diễn bởi tệp tin /dev/tty.

Một lệnh đơn giản để sử dụng khi nói đến standard output là lệnh `echo`. Hãy thực hiện lệnh `echo` cùng với một chuỗi văn bản, và chuỗi văn bản sẽ hiển thị trên STDOUT của tiến trình, thường là màn hình terminal. Ví dụ được hiển thị trong Listing 1.55.

**Listing 1.55:** Sử dụng `echo` command để hiển thị text ra STDOUT
```
$ echo "Hello World" 
Hello World
$
```

Điều thú vị về STDOUT là bạn có thể chuyển hướng nó thông qua các toán tử `redirection operators` trên dòng lệnh. `redirect operator` cho phép bạn thay đổi hành vi mặc định của input và output. Đối với STDOUT, bạn chuyển hướng đầu ra bằng toán tử `>` như được hiển thị trong Listing 1.56.

**Listing 1.56:** Sử dụng STDOUT redirection operator
```
$ grep nologin$ /etc/passwd 
bin:x:1:1:bin:/bin:/sbin/nologin d
aemon:x:2:2:daemon:/sbin:/sbin/nologin 
[...]
$ grep nologin$ /etc/passwd > NologinAccts.txt 
$
$ less NologinAccts.txt 
bin:x:1:1:bin:/bin:/sbin/nologin 
daemon:x:2:2:daemon:/sbin:/sbin/nologin
[...] 
$
```

Như trong ví dụ trên, chúng ta sử dụng lệnh `grep` như bình thường nhưng thêm `redirect operator` ,`>`, và tên tệp vào cuối lệnh. Kết quả là đầu ra của lệnh sẽ được ghi vào tệp NologinAccts.txt thay vì gửi (hiển thị) ra màn hình. Bây giờ có thể xem tệp đầu ra bằng lệnh `less`.

{{< alert type="warning" >}}
Nếu bạn sử dụng toán tử chuyển hướng > và gửi đầu ra tới một tệp đã tồn tại, dữ liệu hiện tại của tệp đó sẽ bị xóa. Hãy thận trọng khi sử dụng toán tử này.
{{< /alert >}}

Để nối dữ liệu vào một tệp có sẵn, bạn cần sử dụng `redirect operator` hơi khác đó là `>>`. Toán tử `>>` sẽ nối dữ liệu vào một tệp có sẵn. Nếu tệp chưa tồn tại, tệp sẽ được tạo và dữ liệu output sẽ được thêm vào tệp đó. Listing 1.57 là ví dụ về cách sử dụng toán tử này.

**Listing 1.57:** Sử dụng STDOUT redirection operator để nối văn bản
```
$ echo "Nov 16, 2019" > AccountAudit.txt 
$
$ wc -l /etc/passwd >> AccountAudit.txt 
$
$ cat AccountAudit.txt 
Nov 16, 2019
44 /etc/passwd
$
```

Lệnh đầu tiên trong Listing 1.57 đặt "Nov 16, 2019" vào tệp AccountAudit.txt. Nếu cần giữ nguyên "Nov 16, 2019" và thêm dữ liệu vào file thì sử dụng toán tử `>>`. Tệp có thể tiếp tục được thêm vào bằng cách sử dụng toán tử `>>` cho các lệnh trong tương lai.

### Redirecting Standard Error

Redirect Stardard Error (Chuyển hướng dòng lỗi chuẩn). `file descripter` cho lỗi của một lệnh hoặc script file là 2. Nó cũng được xác định bằng tên viết tắt là STDERR (Standard Error), theo mặt định thì được hiển thị ở terminal (/dev/tty)

Redirect operator để gửi STDERR tới một tệp tin là `2>`. Tương tự, nếu bạn cần nối nội dung vào tệp tin thì dùng `2>>`. Listing 1.58 là một ví dụ.

**Listing 1.58:** Sử dung STDERR redirection operator
```
$ grep -d skip hosts: /etc/*
grep: /etc/anacrontab: Permission denied 
grep: /etc/audisp: Permission denied
[...]
$
$ grep -d skip hosts: /etc/* 2> err.txt 
/etc/nsswitch.conf:#hosts: db files nisplus nis dns 
/etc/nsswitch.conf:hosts: files dns myhostname
[...]
$
$ cat err.txt
grep: /etc/anacrontab: Permission denied
grep: /etc/audisp: Permission denied
[...]
$
```

Lệnh đầu tiên trong Listing 1.58 dùng để tìm bất kỳ tệp nào nằm trong thư mục /etc/ chứa cụm `host:`. Thật không may, vì người dùng không có quyền root nên một số thông báo lỗi Permission denied được hiện ra. Điều này làm lộn xộn kết quả đầu ra và gây khó khăn cho việc xem tập tin nào chứa lệnh này.

Lệnh thứ hai trong Listing 1.58 redirect STDERR tới tập tin err.txt bằng các sử dụng redirect operator `2>`. Điều này giúp xem tập tin nào có chưa `hosts:`. Nếu cần xem thông báo lỗi, bạn sẽ xem ở tệp err.txt

{{< alert type="info" >}}
Đôi khi bạn muốn ghi standard output và standard error vào cùng một tệp. Trong những trường hợp này, hãy sử dụng toán tử chuyển hướng `&>` để hoàn thành mục tiêu của bạn.
{{< /alert >}}


Nếu bạn không quan tâm đến việc giữ các thông báo lỗi, bạn có thể vứt chúng đi. Điều này được thực hiện bằng cách chuyển hướng STDERR tới tệp /dev/null như được hiển thị trong Listing 1.59.

Listing 1.59: Sử dụng a STDERR redirection operator để loại bỏ error messages
```
$ grep -d skip hosts: /etc/* 2> /dev/null 
/etc/nsswitch.conf:#hosts:    db files nisplus nis dns 
/etc/nsswitch.conf:hosts:     files dns myhostname
[...]
$
```

`/dev/null` đôi khi được gọi là lỗ đen (black hole). Cái tên này xuất phát từ thực tế là bất cứ thứ gì bạn bỏ vào đó đều không thể lấy lại được.

### Regulating Standard Input

Theo mặc định, Standard Input đivào h ệ thống Linux của bạn thông qua bàn phím và/hoặc các thiết bị đầu vào khác. `file descriptor` xác định đầu vào vào tệp lệnh hoặc tập lệnh là 0. Nó cũng được xác định bằng tên viết tắt là STDIN (Standard Input).

Giống như STDOUT và STDERR, bạn cũng có thể redirect STDIN. Redirect Operator là `<`. Lệnh `tr` là một trong số ít command cần phải redirect STDIN. Một ví dụ ở Listing 1.60

Listing 1.60: Sử dụng STDIN redirection operator
```
$ cat Grades.txt
89 76 100 92 68 84 73
$
$ tr " " "," < Grades.txt 
89,76,100,92,68,84,73
$
```

Trong Listing 1.60, tệp Grade.txt chứa nhiều số nguyên khác nhau, được phân tách bằng dấu cách. Lệnh thứ 2 sử dụng `tr` command để thay đổi các dấu cách thành dấu phẩy (,). Vì `tr` command redirect STDIN theo sau là tên tệp. Hãy nhớ rằng lệnh này không thay đổi tệp Grades.txt. Nó chỉ hiển thị cho STDOUT xem tệp sẽ trông như thế nào với những thay đổi này.

Chúng ta cần có một bản tóm tắt ngắn gọn về các redirect operator. Bảng 1.11 là cách để dễ dàng tham khảo.

**TABLE 1.11** Các redirect operator
| Operator | Description |
| :------- | :---------- |
| > | Redirect STDOUT vào một file cụ thể. Nếu file đã tồn tại, ghi đè nội dung file đó. Nếu file không tồn tại thì sẽ tạo mới. |
| >>| Redirect STDOUT vào một file cụ thể. Nếu file đã tồn tại, nối (appends) nội dung mới vào file đó. Nếu file không tồn tại thì sẽ tạo mới. |
| 2> | Redirect STDERR vào một file cụ thể. Nếu file đã tồn tại, ghi đè nội dung file đó. Nếu file không tồn tại thì sẽ tạo mới. |
| 2>> | Redirect STDERR vào một file cụ thể. Nếu file đã tồn tại, nối (appends) nội dung mới vào file đó. Nếu file không tồn tại thì sẽ tạo mới. |
| &> | Redirect STDOUT và STDERR vào một file cụ thể. Nếu file đã tồn tại, ghi đè nội dung file đó. Nếu file không tồn tại thì sẽ tạo mới. |
| &>> | Redirect STDOUT và STDERR vào một file cụ thể. Nếu file đã tồn tại, nối (appends) nội dung mới vào file đó. Nếu file không tồn tại thì sẽ tạo mới. |
| < | Redirect STDIN từ một file cụ thể vào 1 command. |
| <> | Redirect STDIN từ một file cụ thể vào 1 command và redirect STDOUT vào một file cụ thể. |


## Piping Data between Programs

Đường ống (pipe) dùng để chuyển hướng trên hệ điều hành Linux, nó cho phép chúng ta sử dụng hai hoặc nhiều lệnh sao cho đầu ra của một lệnh đóng vai trò trực tiếp làm đầu vào của lệnh tiếp theo. Kết nối trực tiếp giữa các lệnh cho phép chúng hoạt động đồng thời và cho phép dữ liệu được truyền giữa chúng liên tục thay vì phải chuyển qua các tệp văn bản tạm thời hoặc qua màn hình hiển thị. Các đường ống là một chiều tức là luồng dữ liệu chuyển hướng từ trái sang phải qua đường ống.

Ống là một toán tử chuyển hướng đơn giản được biểu thị bằng ký tự ASCII 124 (|), được gọi là thanh dọc, dấu gạch chéo dọc hoặc đường thẳng đứng. Các đường ống (pipe) giúp chúng ta có thể kết hợp hai hoặc nhiều lệnh cùng lúc và chạy chúng liên tiếp. Với pipe bạn có thể chuyển hướng STDOUT, STDIN, STDERR giữa nhiều lệnh trên 1 dòng lệnh.

Cú pháp cơ bản để chuyển hướng bằng pipe như sau:

*COMMAND1 | COMMAND2 [| COMMANDN]...*

Cú pháp trên cho ta biết rằng lệnh đầu tiên COMMAND1 được thực thi, STDOUT của nó được chuyển hướng dưới dạng STDIN sang lệnh thứ 2 COMMAND2. Ngoài ra, bạn có thể kết hợp nhiều lệnh lại với nhau thay vì chỉ hai lệnh. Hãy nhớ rằng bất kỳ lệnh nào trong đường dẫn đều có STDOUT được chuyển hướng dưới dạng STDIN sang lệnh tiếp theo trong đường dẫn. Listing 1.61 sẽ cho chúng ta thấy rõ hơn.

**Listing 1.61:** Sử dụng pipe redirection
```
$ grep /bin/bash$ /etc/passwd | wc -l 
3
$
```

Trong lệnh trên, lệnh đầu tiên trong pipe sử dụng `grep` để tìm kiếm trong tệp passwd bất kì record nào kết thúc bằng */bin/bash*. Về cơ bản, đây là lệnh tìm kiếm tất cả các user dùng shell Bash làm shell mặc định trong tài khoản của họ. Đầu ra từ lệnh đầu tiên sẽ thành đầu vào của lệnh thứ 2. Lệnh `wc -l` sẽ đếm xem lệnh `grep` xuất ra bao nhiêu dòng. Kết quả cho thấy chỉ có 3 tài khoản user sử dụng shell Bash làm shell mặc định.

Chúng ta có thể sáng tạo rất nhiều từ pipe. Listing 1.62 sử dụng 4 command khác nhau để kiểm tra các tài khoản sử dụng shell /sbin/nologin mặc định.

**Listing 1.61:** Sử dụng pipe redirection với nhiều command hơn
```
$ grep /sbin/nologin$ /etc/passwd | cut -d ":" -f 1 | sort | less abrt
adm
avahi
bin chrony [...]
:
```

Trong ví dụ trên, đầu ra từ lệnh `grep` làm đầu vào cho lệnh `cut`, lệnh `cut` ở command thứ 2 chỉ dùng để xoá field đầu tiên khỏi mỗi record của passwd (đó là field username), sử dụng đầu ra này làm đầu vào cho lệnh `sort` để sắp xếp username theo thứ tự bảng chữ cái. Cuối cùng đầu ra của lệnh `sort` làm đầu vào cho lệnh `less` để xem các username này trên màn hình.

Trong trường hợp bạn muốn giữ lại đầu ra của pipe cũng như xem nó thì lệnh `tee` là lệnh hữu ích trong trường hợp này. Tương tự như lắp một cái ống chữ T trong một đường ống nước của nhà bạn. Nước sẽ chảy đi theo nhiều hướng. Tương tự như vậy, `tee` cho phép bạn vừa có thể save output vào 1 file, vừa hiển thị chúng ra màn hình. 

**Listing 1.62:** Sử dụng tee command trong pipe redirection 
```
$ grep /bin/bash$ /etc/passwd | tee BashUsers.txt 
root:x:0:0:root:/root:/bin/bash 
user1:x:1000:1000:Student User One:/home/user1:/bin/bash 
Christine:x:1001:1001::/home/Christine:/bin/bash
$
$ cat BashUsers.txt
root:x:0:0:root:/root:/bin/bash 
user1:x:1000:1000:Student User One:/home/user1:/bin/bash 
Christine:x:1001:1001::/home/Christine:/bin/bash
$
```

Lệnh đầu tiên tìm kiếm trong file passwd bất cứ record nào kết thúc bằng */bin/bash*.  Đầu ra đó được dẫn vào lệnh `tee`, lệnh này sẽ hiển thị đầu ra cũng như lưu nó vào tệp BashUsers.txt. Lệnh `tee` rất hữu ích khi bạn cài đặt phần mềm từ dòng lệnh và muốn xem điều gì đang xảy ra cũng như lưu giữ tệp nhật ký của giao dịch để xem lại sau.

### Using `sed`

Lệnh `sed` là công cụ xử lý văn bản mạnh mẽ và là một tiện ích UNIX lâu đời nhất và phổ biến nhất. Nó được sử dụng để sửa đổi nội dung của một tệp, thường đặt nội dung vào một tệp mới.

Lệnh `sed` có thể lọc văn bản, cũng như thực hiện thay thế trong luồng dữ liệu.

Dữ liệu từ một nguồn/tệp đầu vào được lấy và di chuyển đến không gian làm việc. Toàn bộ danh sách các hoạt động/sửa đổi được áp dụng trên dữ liệu trong không gian làm việc và nội dung cuối cùng được chuyển đến không gian đầu ra tiêu chuẩn.

Trước khi xem một số ví dụ về `sed`, điều quan trọng là phải hiểu cú pháp cơ bản của lệnh này:

*sed [OPTIONS] [SCRIPT]... [FILENAME]*

Theo mặc định, `sed` sẽ sử dụng văn bản từ STDIN để sửa đổi nó theo thông số đã chỉ định của lệnh. Một ví dụ được hiển thị trong Listing 1.64.

**Listing 1.64:** Sử dụng `sed` để sử đổi STDIN
```
$ echo "I like cake." | sed 's/cake/donuts/' 
I like donuts.
$
```

Trong lệnh trên đầu ra văn bản từ lệnh `echo` được chuyển thành đầu vào vào của `sed`. Lệnh `s` (substitute - thay thế) của `sed` nếu chuỗi văn bản là *cake* được tìm thấy nó sẽ được thay thể bởi *donuts*. Lưu ý rằng toàn bộ lệnh sau `sed` được coi là SCRIPT và được đặt trong dấu ngoặc đơn. Cũng lưu ý rằng các từ văn bản được phân tách khỏi lệnh s, dấu ngoặc kép và các từ khác bằng dấu gạch chéo (/).

Hãy nhớ rằng chỉ sử dụng lệnh `s` sẽ không thay đổi tất cả các phiên bản của một từ trong luồng văn bản. Liệt kê 1.65 cho thấy một ví dụ về điều này.

**Listing 1.65:** Sử dụng `sed` để thay đổi toàn bộ STDIN text
```
$ echo "I love cake and more cake." | sed 's/cake/donuts/' 
I love donuts and more cake.
$
$ echo "I love cake and more cake." | sed 's/cake/donuts/g' 
I love donuts and more donuts.
$
```

Trong lệnh đầu tiên của Listing 1.65, chỉ từ *cake* đầu tiên được sửa đổi thành *donuts*. Tuy nhiên trong lệnh thứ hai, `g` (viết tắt của global) đã được thêm vào cuối của lệnh `sed`. Điều này sẽ thay đổi tất cả các từ *cake* thành *donuts*. Bạn cũng  có thể sửa đổi văn bản được lưu trữ trong một file như ví dụ trong Listing 1.66.

**Listing 1.66:** Sử dụng `sed` để chỉnh sửa nội dung file
```
$ cat cake.txt
Christine likes chocolate cake. 
Rich likes lemon cake.
Tim only likes yellow cake.
Samantha does not like cake.
$
$ sed 's/cake/donuts/' cake.txt 
Christine likes chocolate donuts. 
Rich likes lemon donuts.
Tim only likes yellow donuts.
Samantha does not like donuts.
$
$ cat cake.txt
Christine likes chocolate cake. 
Rich likes lemon cake.
Tim only likes yellow cake. 
Samantha does not like cake.
$
```

Có thể bạn nghĩ `sed` hoạt động trên toàn bộ văn bản của file, nhưng thực tế không phải vậy. `sed` hoạt động trên từng dòng riêng lẻ của văn bản. Do đó, trong ví dụ trên, nếu từ *cake* được tìm thấy nhiều lần trong một dòng tệp văn bản, bạn cần sử dụng lệnh *g* chung thay đổi tất cả các các từ *cake* của dòng.

Các ví dụ trên là khả năng thay thế văn bản của `sed`, nhưng bạn cũng có thể xoá văn bản nữa. Để làm như vậy, bạn sử dụng cú pháp *'PATTERN/d'* cho SCRIPT của lệnh `sed`. Một ví dụ được hiển thị trong Listing 1.67. Lưu ý dòng tệp *cake.txt* có chứa
từ *Christine* không được hiển thị thành STDOUT. Nó đã bị “xóa” ở đầu ra nhưng vẫn tồn tại trong tệp văn bản.

**Listing 1.67:** Sử dụng `sed` để xoá văn bản trong file.
```
$ sed '/Christine/d' cake.txt 
Rich likes lemon cake.
Tim only likes yellow cake. 
Samantha does not like cake. 
$
```

Bạn cũng có thể thay đổi toàn bộ dòng văn bản. Để thực hiện điều này, bạn sử dụng cú pháp *'ADDRESScNEWTEXT'* cho SCRIPT của lệnh `sed`. *ADDRESS* đề cập đến số thứ tự của dòng văn bản mà bạn đang muốn thay đổi. *NEWTEXT* là nội dung mới mà bạn muốn thay đổi. Ví dụ ở Listing 1.68.

**Listing 1.68:** Sử dụng `sed` để thay đổi toàn bộ dòng văn bản.
```
$ sed '4cI am a new line' cake.txt 
Christine likes chocolate cake. 
Rich likes lemon cake.
Tim only likes yellow cake.
I am a new line 
$
```

`sed` có một số tùy chọn lệnh khá hữu ích. Các tuỳ chọn phổ biến được liệt kê trong Bảng 1.12.

**TABLE 1.12** Các tuỳ chọn phổ biến của `sed`
| Short | Long | Description |
| :---- | :--- | :---------- |
| -e script | -expression=script | Chỉ định các lệnh chỉnh sửa tại dòng lệnh, hoạt động trên tệp và đưa đầu ra ra ngoài.|
| -f script | -file=script | Chỉ định một scriptfile chứa lệnh sed, hoạt động trên tệp và đưa đầu ra ra ngoài. |
| -f | --regexp-extended | Sử dụng các biểu thức chính quy mở rộng (ERE) trong *script* |

Một tùy chọn tiện dụng để sử dụng là tùy chọn `-e`. Điều này cho phép bạn sử dụng nhiều tập lệnh trong lệnh `sed`. Một ví dụ được hiển thị trong Listing 1.69.

**Listing 1.69:** Sử dụng `sed -e` sể dùng multiple scripts
```
$ sed -e 's/cake/donuts/ ; s/like/love/' cake.txt 
Christine loves chocolate donuts.
Rich loves lemon donuts.
Tim only loves yellow donuts.
Samantha does not love donuts. 
$
```

Hãy chú ý đến sự thay đổi cú pháp trong ví dụ trên. Không chỉ tùy chọn `-e` được sử dụng mà tập lệnh cũng hơi khác một chút. Bây giờ tập lệnh chứa dấu chấm phẩy (;) giữa hai lệnh con. Điều này cho phép cả hai lệnh được xử lý trên luồng văn bản.

### Generating Command Lines

Tạo ra các command-line là một kỹ năng khá quan trọng. Có một số phương pháp khác nhau mà bạn có thể sử dụng. Một trong số đó là `xargs`. Bằng cách chuyển các STDOUT từ các lệnh khác vào `xargs` bạn có thể xây dựng các command một cách nhanh chóng. Ví dụ ở Listing 1.70.

Listing 1.70: Sử dụng `xargs` command
```
$ touch EmptyFile1.txt EmptyFile2.txt EmptyFile3.txt 
$
$ ls EmptyFile?.txt
EmptyFile1.txt EmptyFile2.txt EmptyFile3.txt
$
$ ls -1 EmptyFile?.txt | xargs -p /usr/bin/rm
/usr/bin/rm EmptyFile1.txt EmptyFile2.txt EmptyFile3.txt ?...n 
$
```

Trong ví dụ trên, 3 tệp trống đã được tạo bằng lệnh touch. Lệnh thứ 3 sử dụng pipe. Với command đầu tiên có tác dụng là liệt kê tất cả các file có tên là EmptyFile?.txt với ? có thể thay thế được bằng ký tự nào đó. Đầu ra từ *ls* được chuyển sang command `xargs` như là một STDIN. Lệnh `xargs` sử dụng tùy chọn `-p`. Tùy chọn này khiến tiện ích `xargs` dừng và xin phép trước khi thực thi lệnh dòng lệnh được xây dựng. Lưu ý rằng tham chiếu thư mục tuyệt đối cho lệnh rm được sử dụng (lệnh rm sẽ được trình bày chi tiết hơn trong Chương 4). Điều này đôi khi cần thiết khi sử dụng `xargs`, tùy thuộc vào bản phân phối của bạn.

Lệnh đã tạo, trong Listing 1.70, cố gắng loại bỏ tất cả ba tệp trống bằng một lệnh `rm`. Chúng ta gõ *n* và nhấn phím Enter để giữ lại ba tệp thay vì xóa chúng, vì chúng cần thiết cho ví dụ tiếp theo.
Một phương pháp khác để tạo nhanh các lệnh dòng lệnh là sử dụng tính năng mở rộng shell. Kỹ thuật ở đây đặt lệnh để thực thi trong dấu ngoặc đơn và đặt trước lệnh đó bằng ký hiệu đô la ($). Một ví dụ về phương pháp này được hiển thị trong Listing 1.71.

Listing 1.71: Sử dụng $() để create commands
```
$ rm -i $(ls EmptyFile?.txt)
rm: remove regular empty file ‘EmptyFile1.txt’? y 
rm: remove regular empty file ‘EmptyFile2.txt’? y 
rm: remove regular empty file ‘EmptyFile3.txt’? y 
$
```

Trong Listing 1.71, lệnh `ls` lại được sử dụng để liệt kê bất kỳ tệp nào có tên EmptyFile**n**.txt. Bởi vì lệnh được bao bọc bởi các ký hiệu $() nên nó không hiển thị thành STDOUT. Thay vào đó, tên tệp được chuyển tới lệnh `rm -i` để hỏi xem có xóa từng tệp được tìm thấy hay không. Phương pháp này cho phép bạn rất sáng tạo khi xây dựng các lệnh một cách nhanh chóng.


