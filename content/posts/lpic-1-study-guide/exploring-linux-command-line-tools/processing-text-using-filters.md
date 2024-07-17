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