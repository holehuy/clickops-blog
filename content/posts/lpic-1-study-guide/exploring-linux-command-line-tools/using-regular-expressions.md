---
title: "LPIC-1 Study Guide: Using Regular Expressions"
date: 2024-07-04T06:00:20+06:00
hero: /images/posts/lpic-1/using-regular-expressions.jpg
description: "LPIC-1 Study Guide: Using Regular Expressions"
menu:
  sidebar:
    name: "Using Regular Expressions"
    identifier: using-regular-expressions
    parent: exploring-linux-command-line-tools
    weight: 4
---

Biểu thức chính quy (Regular Expression - Regex) là một chuỗi các ký tự đặc biệt và ký tự thông thường được sử dụng để mô tả một mẫu chuỗi. Regex được sử dụng để tìm kiếm, thay thế và thao tác với văn bản. Trong bài này chúng ta sẽ tìm hiểu về các tiện ích để thực hiện biểu thức chính quy.

## Sử dụng `grep`

Một công cụ tuyệt vời để sàng lọc văn bản đó là `grep`. Lệnh `grep` rất mạnh trong việc sử dụng các biểu thức chính tuy, điều này sẽ giúp lọc các tệp văn bản. Nhưng trước khi đề cập đến những vấn đề đó, hãy xem qua Bảng 1.9 để biết các tùy chọn tiện ích `grep` thường được sử dụng.

**TABLE 1.9:** Các options phổ biến của `grep` command
| Short         | Long                      | Description                                                         |
| :------------ | :------------------------ | :------------------------------------------------------------------ |
| -c            | --count                   | Hiển thị số lượng bản ghi trong tệp có khớp với PATERN. |
| -d action     | --directories=action      | Hành vi của lệnh grep khi gặp thư mục (directory), nếu action được thiết lập là read thì nó sẽ đọc thư mục đó như một tệp thông thường, nếu action được thiết lập là skip nó sẽ bỏ qua thư mục đó và không tìm kiếm bên trong, nếu action được thiết lập là recurse thì nó sẽ tìm kiếm bên trong thư mục một cách đệ quy giống như sử dụng tuỳ chọn -R, -r hoặc --recursive. |
| -E            | --extended-regexp         | Cho phép bạn chỉ định PATTERN (mẫu tìm kiếm) dưới dạng biểu thức chính quy mở rộng (extended regular expression). |
| -i            | --ignore-case             | `grep` sẽ không phân biệt chữ hoa và chữ thường khi so khớp PATTERN (mẫu tìm kiếm) với các dòng trong tệp tin. |
| -R, -r        | --recursive               | Tìm kiếm nội dung của một thư mục và tất cả các thư mục con (subdirectory) trong cây thư mục đó một cách đệ quy (recursive), bạn có thể sử dụng tùy chọn -r hoặc -R với lệnh grep. |
| -v            | --invert-match            | Chỉ hiển thị các bản ghi trong tệp văn bản không khớp với PATERN. |

Cú pháp cơ bản của lệnh `grep` như sau:

*grep [OPTION] PATTERN [FILE...]*

Một ví dụ đơn giản được hiển thị trong Listing 1.49. Nếu không có tùy chọn nào được sử dụng và tiện ích `grep` được sử dụng để tìm kiếm word root (PATTERN) trong /etc/passwd (FILE).

**Listing 1.49:** Sử dụng lệnh `grep` để tìm kiếm trong một file
```
$ grep root /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
operator:x:11:0:operator:/root:/sbin/nologin 
$
```

Lưu ý rằng lệnh `grep` trả về mỗi bản ghi tệp (dòng) khớp với PATTERN, trong trường hợp này là từ *root*. Bạn cũng có thể đưa một loạt các PATTERN vào một file để sử dụng với `grep`. Ví dụ được thực hiện trong Listing 1.50.

**Listing 1.50:** Sử dụng `grep` command để search qua các pattern được lưu trong file thay vì cung cấp pattern cụ thể trên terminal
```
$ cat accounts.txt 
sshd
Christine 
nfsnobody
$
$ fgrep -f accounts.txt /etc/passwd
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin 
Christine:x:1001:1001::/home/Christine:/bin/bash 
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin 
$
$ grep -F -f accounts.txt /etc/passwd 
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin 
Christine:x:1001:1001::/home/Christine:/bin/bash 
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin 
$
```

Các PATTERN được lưu trong file *accounts.txt*, tệp này được hiển thị bởi lệnh `cat` trong Listing 1.50. Tiếp theo lệnh `fgrep` được sử dụng với options `-f` để chỉ ra file chứa các PATTERN. Lệnh này tìm kiếm trong *etc/passwd* các record khớp với các PATTERN được lưu trong file accounts.txt và kết quả được hiển thị.

Lệnh thứ 3 trong Listing 1.50 có chứa option `-F`. Lệnh `grep -F` tương đương với lệnh `fgrep`, đó là lý do vì sao hai lệnh này cho ra kết quả giống nhau.

## Tìm hiểu về Basic Regular Expressions

Biểu thức chính quy cơ bản - Basic Regular Expressions (BREs) bao gồm các ký tứ, chẳng hạn như dấu chấm theo sau là dấu hoa thị `.*` để biểu thị là nhiều ký tự, và một dấu chấm `.` để biểu thị là một ký tự. Cũng có thể sử dụng dấu ngoặc vuông để biểu thị nhiều ký tự, ví dụ như `[a, e, i, o, u]` (bạn không cần phải bao gồm dấu phẩy). Hoặc là một phạm vi các ký tự chẳng hạn như `[A-z]`. Khi sử dụng dấu ngoặc vuông, biểu thức đó gọi là biểu thức khung (hoặc có thể gọi là biểu thức ngoặc) *(bracket expression)*.

Để tìm các record trong văn bản bắt đầu bằng các ký tự cụ thể, bạn có thể đặt trước chúng bằng ký tự dấu mũ `^`. Để tìm các record trong văn bản kết thúc bằng các ký tự cụ thể, hãy thêm ký tự đô la `$` đằng sau chúng. Cả ký tự dấu mũ `^` và ký tự đô la `$` đều được gọi là ký tự neo *(anchor characters)* trong BREs.

{{< alert type="info" >}}
Bạn sẽ thấy trong tài liệu và mô tả kỹ thuật các tên khác nhau cho biểu thức chính quy Regular Expressions. Tên có thể được rút ngắn thành `regex`  hoặc `regexp`.
{{< /alert >}}

Sử dụng các pattern của biểu thức chính quy khá đơn giản với `grep`. Ví dụ trong Listing 1.51.

**Listing 1.51:** Sử dụng `grep` command với một BRE pattern
```
$ grep daemon.*nologin /etc/passwd 
daemon:x:2:2:daemon:/sbin:/sbin/nologin
[...]
daemon:/dev/null:/sbin/nologin
[...]
$
$ grep root /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
operator:x:11:0:operator:/root:/sbin/nologin 
$
$ grep ^root /etc/passwd 
root:x:0:0:root:/root:/bin/bash
$
```

Trong ví dụ trên, lệnh `grep` đầu tiên sử dụng BRE pattern là `.*` (cụ thể là `daemon.*nologin`). Trong trường hợp này, `grep` sẽ tìm kiếm trong tập tin passwd để lấy các record nào, dòng nào chứa chuỗi `daemon` và đồng thời chứ chuỗi `nologin` đằng sau `daemon`.

Hai lệnh `grep` tiếp theo đang tìm kiếm các record có chứa chuỗi `root` trong tập tin passwd, lệnh đầu tiên chỉ cần chứa chuỗi `root` là được, còn lệnh thứ 2 thì `grep` chỉ hiển thị các record được bắt đầu bằng chuỗi `root` bằng cách sử dụng ký tự neo `^`.

{{< alert type="success" >}}
Nếu bạn muốn xử lý tốt hơn các biểu thức chính quy, có một số tài liệu hay. Tôi yêu thích nhất là Chương 20 trong cuốn Linux Command Line and Shell Scripting Bible của Blum và Bresnahan (Wiley, 2015).
{{< /alert >}}

Option `-v` rất hữu ích khi kiểm tra các tệp cấu hình của bạn bằng tiện ích `grep`. Nó tạo ra một danh sách các bản ghi tệp văn bản KHÔNG CHỨA (không khớp) với pattern. Listing 1.52 cho thấy một ví dụ về việc tìm tất cả các bản ghi trong tệp mật khẩu không kết thúc bằng *nologin*. Lưu ý rằng BRE pattern đặt `$` ở cuối từ. Nếu bạn đặt `$` trước từ này, nó sẽ được coi là tên biến (biến môi trường) thay vì là BRE pattern.

**Listing 1.52:** Sử dụng lệnh `grep` để kiểm tra tệp tin passwd
```
$ grep -v nologin$ /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
sync:x:5:0:sync:/sbin:/bin/sync
[...] 
Christine:x:1001:1001::/home/Christine:/bin/bash 
$
```

{{< alert type="success" >}}
Nếu bạn cần lọc tất cả dòng trống trong một tệp (chỉ hiển thị các dòng có văn bản), hãy sử dụng lệnh `grep` với tuỳ chọn `-v` để đảo ngược các pattern phù hợp. Sau đó sử dụng các ký tự neo `^` và `$` để tạo thành lệnh `grep -v ^$ filename` sẽ chỉ hiển thị các dòng có văn bản.
{{< /alert >}}

Một nhóm các biểu thức khung đặc biệt thì được goi là *character classes*. Các biểu thức khung này có tên được định nghĩa sẵn, và được coi là shortcut của các biểu thức khung. Mô tả cụ thể của chúng sẽ dựa trên local environment variable là **LC_CTYPE**. Bảng 1.10 cho thấy các **character class** được sử dụng phổ biến.

**TABLE 1.10** Các `character class` được sử dụng phổ biến
| Class | Descriptions |
| :---- | :----------- |
| [:alnum:] | Khớp với mọi ký tự chữ cái và số nào (viết hoa lẫn viết thường) và tương đương với việc sử dụng biểu thức ngoặc [0-9A-Za-z] |
| [:alpha:] | Khớp với mọi ký tự chữ cái (viết hoa lẫn viết thường) và tương đương với việc sử dụng biểu thức ngoặc [A-Za-z] |
| [:blank:] | Khớp với mọi ký tự trống nào, chẳng hạn như `tab` và dấu cách |
| [:digit:] | Khớp với mọi ký tự số nào và tương đương cách sử dụng biểu thức ngoặc [0-9] |
| [:lower:] | Khớp với mọi ký tự chữ cái viết thường nào và tương đương với việc sử dụng biểu thức ngoặc [a-z] |
| [:punct:] | Khớp với các ký tự dấu chấm câu, chẳng hạn như `!`, `#`, `$` và `@` |
| [:space:] | Khớp các ký tự khoảng trắng, chẳng hạn như `tab`, form feed và dấu cách |
| [:upper:] | Khớp với mọi ký tự chữ cái viết hoa và bằng với việc sử dụng biểu thức ngoặc [A-Z] |


Để sử dụng `character classes` bằng lệnh `grep` hãy đặt nó trong một biểu thức ngoặc khác. Ví dụ trong Listing 1.53

**Listing 1.53:** Sử dụng `grep` command và `character class`
```
$ cat random.txt
42
Flat Land 
Schrodinger's Cat 
0010 1010
0000 0010
$
$ grep [[:digit:]] random.txt 
42
0010 1010
0000 0010
$
```

Lưu ý rằng cần dấu ngoặc vuông bổ sung để sử dụng `character class` với `grep`. Do đó, để sử dụng `[:digit:]`, bạn phải nhập `[[:digit:]]` khi sử dụng `character class` này bằng lệnh `grep`.

{{< alert type="info" >}}
Nếu bạn cần tìm kiếm một ký tự đặc biệt trong tập tin, chẳng hạn như ký tự neo $, hãy đặc trước nó một dấu gạch chéo ngược (\). Điều này cho `grep` biết rằng bạn đang tìm kiếm ký tự đó ($) chứ không phải là sử dụng nó như là ký tự neo trong biểu thức chính quy.
{{< /alert >}}

## Tìm hiểu về Extended Regular Expressions

Biểu thức chính quy mở rộng - Extended Regular Expressions (EREs) cho phép tạo các pattern phức tạp hơn. Ví dụ: ký hiệu thanh dọc (|) cho phép bạn chỉ định hai từ hoặc bộ ký tự có thể khớp. Bạn cũng có thể sử dụng dấu ngoặc đơn để chỉ định các biểu thức con bổ sung.

Sử dụng các biểu thức chính quy mở rộng ERE khá phức tạp. Một vài ví dụ sử dụng `grep` với ERE rất hữu ích, chẳng hạn như những ví dụ được hiển thị trong Listing 1.54.

**Listing 1.54:** Sử dụng lệnh `grep` với ERE pattern
```
$ grep -E "^root|^dbus" /etc/passwd 
root:x:0:0:root:/root:/bin/bash 
dbus:x:81:81:System message bus:/:/sbin/nologin 
$
$ egrep "(daemon|s).*nologin" /etc/passwd 
bin:x:1:1:bin:/bin:/sbin/nologin 
daemon:x:2:2:daemon:/sbin:/sbin/nologin 
[...]
$
```

Trong lệnh đầu tiên, lệnh `grep` sử dụng option `-E` để cho biết là pattern là biểu thức chính quy mở rộng. Nếu bạn không sử dụng option `-E` thì sẽ hiển thị các kết quả không như mong muốn. Và dấu nháy kép xung quanh biểu thức chính quy mở rộng ERE là cần thiết, để không bị hiểu sai. `grep -E "^root|^dbus" /etc/passwd` dùng để tìm kiếm trong tệp passwd bất kỳ record nào bắt đầu bằng từ `root` hoặc từ `dbus`. Do đó, dấu mũ (^) được đặt trước mỗi từ và thanh dọc (|) phân tách các từ để cho biết rằng record có thể bắt đầu bằng một trong hai từ.

Trong lệnh thứ hai, lệnh `egrep` được sử dụng. Lệnh `egrep` tương đương với việc sử dụng lệnh `grep -E`. ERE pattern ở lệnh thứ hai này dùng dấu nháy kép để tránh bị hiểu sai context, và sử dụng dấu ngoặc đơn để chỉ thị biểu thức con. Biểu thức con ở đây đang là một sự lựa chọn, được biểu thị bằng thanh dọc (|), chọn giữa từ `daemon` và chữ cái `s`. Ký hiệu `.*` được sử dụng để biểu thị có thể có bất kỳ ký tự gì ở giữa lựa chọn biểu thức con và từ `nologin` trong bản ghi tệp văn bản. 

Có rất nhiều thứ cần phải nghiên cứu. Tuy nhiên, dù các mẫu BRE và ERE có khó đến đâu, chúng cũng đáng để tìm hiểu và học tập để có thể sử dụng lệnh `grep` một cách thuần thục.