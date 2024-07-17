---
title: "LPIC-1 Study Guide: Editing Text Files"
date: 2024-07-02T06:00:20+06:00
hero: /images/posts/lpic-1/editing-text-files.jpg
description: "LPIC-1 Study Guide: Editing Text Files"
menu:
  sidebar:
    name: "Editing Text Files"
    identifier: editing-text-files
    parent: exploring-linux-command-line-tools
    weight: 2
---


Thao tác với văn bản là một nhiệm vụ thường xuyên khi quản lý hệ thống Linux. Cho dù bạn cần chỉnh sửa một tệp cấu hình hoặc tạo một tập lệnh `shell`, khả năng sử dụng trình soạn thảo văn bản tương tác tại dòng lệnh là một kỹ năng quan trọng mà chúng ta cần có.

## Các Text Editor

Có 3 trình soạn thảo văn bản phổ biến trên Linux (Linux command-line editor) là:
- emacs
- nano
- vim

`nano` sẽ là một trình soạn thảo văn bản tốt để bắt đầu sử dụng nếu bạn chưa bao giờ làm việc với các trình soạn thảo dạng command-line hoặc chỉ sử dụng các trình soạn thảo có giao diện đồ hoạ. Để bắt đầu sử dụng `nano`, hãy gõ `nano` và theo sau là tên tệp bạn muốn chỉnh sửa hoặc muốn tạo.

**FIGURE 1.1** Sử dụng nano text editor

{{< img src="/assets/images/posts/lpic-1/figure1_1.png" align="center" title="using nano text editor" >}}

Bản phím tắt (shortcut list) là một trong những tính năng hữu ích nhất của `nano` editor. Danh sách này ở đáy cửa sổ hiển thị các lệnh phổ biến nhất và các phím tắt tương ứng của chúng.

Kí hiệu dấu mũ `^` trong danh sách này cho biết phím `Ctrl` cần được sử dụng. Ví dụ, để di chuyển xuống một trang, bạn nhấn và giữ phím `Ctrl`, sau đó nhấn phím `V`.

Để xem các lệnh bổ sung, hãy nhấn tổ hợp phím `Ctrl + G` để hiện thị trợ giúp.

{{< alert type="info" >}}Trong hệ thống trợ giúp của `nano` editor, bạn sẽ thấy một số tổ hợp phím được biểu thị bằng `M-k`. Một ví dụ là `M-W` để lặp lại một tìm kiếm.

Đây là các tổ hợp phím `metacharacter`, và `M` biểu thị phím `Esc`, `Alt` hoặc `Meta` tuỳ thuộc vào cấu hình bàn phím của bạn. Ký tự `k` đơn giản đại diện cho một phím trên bàn phím, chẳng hạn như `W`
{{< /alert >}}

`nano` editor rất tuyệt vời để sử dụng cho các chỉnh sửa tệp văn bản đơn giản. Tuy nhiên, nếu bạn cần một trình soạn thảo văn bản mạnh hơn để tạo các chương trình hoặc các tập lệnh shell, các lựa chọn phổ biến bao gồm `emacs` và `vim`.

`emacs` và `vim` cung cấp nhiều tính năng nâng cao hơn so với `nano`, như hỗ trợ lập trình, tuỳ chỉnh nâng cao và khả năng tự động hoá nhiều tác vụ. Các trình soạn thảo này thường được sử dụng bởi các lập trình viên và các nhà phát triển phần mềm chuyên nghiệp, đặc biệt là khi làm việc trong môi trường Linux command-line.

{{< alert type="info" >}}
Một số tiện ích như `crontab` *(được đề cập ở Chương 9)* sử dụng editor mặc định (cũng được gọi là *starndard editor*) chẳng hạn như `vim`. Nếu bạn mới làm quen với việc chỉnh sửa văn bản, bạn sẽ có xu hướng muốn dùng các editor dễ sử dụng, nên việc sử dụng editor nâng cao là cả một vấn đề.

Bạn có thể thay đổi trình soạn thảo tiêu chuẩn của tài khoản của mình thông qua các biến môi trường `EDITOR` và `VISUAL`. Biến `EDITOR` ban đầu dành cho các trình soạn thảo dòng *(based-line editor)* chẳng hạn như ed utility. Biến `VISUAL` dành cho các trình soạn thảo màn hình (trình soạn thảo văn bản chiếm toàn bộ màn hình, như `nano`, `emacs` và `vim`).

Thay đổi trình soạn thảo tiêu chuẩn của bạn thành trình soạn thảo mong muốn bằng cách gõ, ví dụ: export EDITOR=nano tại dòng lệnh. Làm tương tự với biến môi trường VISUAL. Tốt hơn nữa, hãy thêm các dòng này vào tệp môi trường (được đề cập ở Chương 9) để chúng được thiết lập tự động cho bạn mỗi khi đăng nhập vào hệ thống Linux.
{{< /alert >}}

Để bắt đầu sử dụng trình soạn thảo `emacs`, hãy gõ `emacs` kèm theo sau là tên tệp bạn muốn chỉnh sửa hoặc tạo. Hình 1.2 hiển thị màn hình `emacs` editor đang chỉnh sửa một tệp mới được tạo với tên "MyFile.txt".

**FIGURE 1.2** Sử dụng `emacs` editor
{{< img src="/assets/images/posts/lpic-1/figure1_2.png" align="center" title="using emacs text editor" >}}

Thêm và sửa đổi văn bản, cũng như di chuyển xung quanh trình soạn thảo này thì khá đơn giản. Tuy nhiên, để khai thác được sức mạnh của trình soạn thảo `emacs`, bạn cần phải học các phím tắt khác nhau. Dưới đây là một vài ví dụ về các phím tắt:

- Nhấn tổ hợp phím **Ctrl+X**, sau đó nhấn **Ctrl+S** để lưu nội dung vào tệp tin.
- Nhấn tổ hợp phím **Ctrl+X**, sau đó nhấn **Ctrl+C** để thoát khỏi trình soạn thảo.
- Nhấn tổ hợp phím **Ctrl+H**, rồi nhấn phím **T** để truy cập hướng dẫn sử dụng `emacs`.

Lưu ý rằng trong tài liệu hướng dẫn của trình soạn thảo `emacs`, phím **Ctrl** được biểu diễn bằng một chữ cái đơn **C**. Để kết hợp thêm một phím khác, tài liệu sử dụng dấu gạch ngang **(-)** thay vì dấu cộng **(+)** như thông thường.

Mặc dù các lệnh của `emacs` hơi phức tạp khi bạn bắt đầu sử dụng trình soạn thảo này nhưng lợi ích của học trình soạn thảo `emacs` bao gồm:

- Các lệnh chỉnh sửa được sử dụng trong `emacs` cũng có thể được dùng để nhanh chóng chỉnh sửa các lệnh bạn nhập ở shell's command line.
- Trình soạn thảo `emacs` có một phiên bản giao diện đồ họa với tất cả các tính năng chỉnh sửa giống nhau.
- Bạn có thể tập trung vào các tính năng của trình soạn thảo mà bạn cần nhất và sau đó mới học các khả năng nâng cao của nó.

{{< alert type="info" >}}
Trình soạn thảo văn bản `emacs` thường không được cài đặt theo mặc định. Cài đặt phần mềm được đề cập trong Chương 2. Tên gói phần mềm của nó cũng là `emacs`.
`{{< /alert >}}

Trước khi chúng ta xem xét sử dụng trình soạn thảo `vim`, chúng ta cần phải nói về `vim` so với `vi`. Trình soạn thảo `vi` là một trình soạn thảo văn bản trên Unix, và khi nó được viết lại dưới dạng công cụ mã nguồn mở, nó đã được cộng đồng cải thiện. Vì vậy, `vim` là từ viết tắt của "vi improved" tức là cũng là vi nhưng đã được cải thiện :v.

Thường thì bạn sẽ thấy lệnh vi sẽ khởi chạy trình soạn thảo `vim`. Trên một số bản phân phối khác, chỉ có lệnh `vim` mới có thể khởi tạo trình soạn thảo `vim`. Dôi khi cả 2 lệnh đều hoạt động. Listing 1.26 minh hoạ việc sử dụng `which` để xác định bản phân phối CentOs đang sử dụng lệnh nào.

**Listing 1.26:** Sử dụng `which` để xác định editor command
```
$ which vim
/urs/bin/vim
$
$ which vi
alias vi='vim'
/usr/bin/vim
$
```

Listing 1.26 cho thấy bản phân phối CentOS này đã đặt bí danh (alias) cho lệnh `vi` để trỏ tới lệnh `vim`. Do đó, trên bản phân phối này, `vi` và `vim` đều sẽ khởi chạy trình soạn thảo `vim`. Điều này có nghĩa là ngay cả khi người dùng gõ lệnh `vi` thì hệ thống vẫn sẽ khởi chạy trình soạn thảo `vim` thay vì trình soạn thảo `vi` cơ bản. Đây là một ví dụ về cách các bản phân phối Linux có thể tuỳ chỉnh các công cụ cơ bản để cung cấp trải nghiệm người dùng tốt hơn.

{{< alert type="warning" >}}
Một số bản phân phối như Ubuntu không cài đặt trình soạn thảo `vim` mặc định. Thay vào đó, họ sử dụng một phiên bản thay thế gọi là `vim.tiny`, phiên bản này sẽ không cho phép bạn thử nghiệm tất cả các lệnh `vim` khác nhau được chúng ta đề cập ở đây.

Bạn có thể kiểm tra bản phân phối của mình để xem có cài đặt `vim` hay không bằng cách lấy tên tập tin chương trình `vim`. Gõ lệnh `type vi` và nhấn Enter, nếu bạn nhận được lỗi hoặc một bí danh, thì nhập `type vim`. Sau khi nhận được thư mục và tên tập tin của chương trình, hãy gõ lệnh `readlink -f` và theo sau nó bằng thư mục và tên tập tin - ví dụ: `readlink -f /usr/bin/vi`. Nếu bạn thấy `/usr/bin/vi.tiny`, bạn cần hoặc chuyển sang một bản phân phối khác để thực hành các lệnh `vim`, hoặc cài đặt gói `vim` (xem Chương 2).
{{< /alert >}}

Được rồi, hãy bắt đầu sử dụng trình soạn thảo vim, bạn có thể gõ lệnh `vim` hoặc `vi` tuỳ thuộc vào bản phân phối của bạn, tiếp theo là tên tập tin mà bạn muốn chỉnh sửa hoặc tạo mới.

Hình 1.3 minh hoạ màn hình trình soạn thảo văn bản vim đang hoạt động.

**FIGURE 1.3**  Sử dụng vim editor
{{< img src="/assets/images/posts/lpic-1/figure1_3.png" align="center" title="using vim text editor" >}}

Trong hình 1.3, tập tin đang được chỉnh sửa có tên là numbers.txt. Trình soạn thảo `vim` hoạt động với dữ liệu của tập tin trong một vùng đệm của bộ nhớ, và vùng đệm này được hiển thị lên màn hình. Nếu bạn mở `vim` mà không có tên tập tin, hoặc tên tập tin bạn nhập chưa tồn tại, `vim` sẽ bắt đầu một vùng đệm mới để chỉnh sửa.

Trình soạn thảo `vim` có một khu vực thông báo gần dòng cuối cùng. Nếu bạn vừa mở một tập tin đã tạo trước đó, nó sẽ hiển thị tên tập tin cùng với số dòng và ký tự đã đọc vào vùng đệm. Nếu bạn đang tạo một tập tin mới, bạn sẽ thấy **[New File]** trong khu vực thông báo.

## Tìm hiểu các Mode của vim

Trình soạn thảo vim có ba chế độ tiêu chuẩn như sau:

**Command Mode** Đây là chế độ mà vim sử dụng khi bạn mới vào vùng đệm, nó đôi khi còn được gọi là *Normal Mode*. Ở đây bạn nhập các phím lệnh để thực hiện các lệnh. Ví dụ, nhấn phím `J` sẽ di chuyển con trỏ xuống một dòng. Command Mode là chế độ tốt nhất để di chuyển nhanh trong vùng đệm (buffer area).

**Insert Mode** Cũng được gọi là *Edit Mode* hoặc *Entry Mode*. Đây là chế độ mà bạn có thể thực hiện chỉnh sửa đơn giản. Không có nhiều lệnh hay phím đặc biệt cho chế độ này. Bạn vào chế độ này từ *Command Mode* bằng cách nhấn phím `I`. Lúc này thông báo **--Insert--** sẽ hiển thị trong khu vực thông báo. Bạn thoát khỏi chế độ này bằng cách nhấn phím `Esc`.

**Ex Mode** Chế độ này đôi khi cũng được gọi là *Colon Commands Mode* bởi vì mọi lệnh nhập vào đây đều bắt đầu bằng dấu hai chấm (:). Ví dụ, để thoát khỏi trình soạn thảo vim mà không lưu bất kỳ thay đổi nào, bạn gõ `:q` và nhấn phím Enter.

## Khám phá các quy trình chỉnh sửa văn bản cơ bản

Khi khởi chạy trình soạn thảo `vim`, bạn sẽ bắt đầu ở **Command Mode**, nên việc hiểu một vài lệnh được sử dụng để di chuyển trong chế độ này là rất quan trọng. Bảng 1.2 chứa một số lệnh di chuyển thường được sử dụng.

**TABLE 1.2** Các lệnh di chuyển thường được sử dụng
| Keystroke(s)  | Descriptions |
| :------------ | :------------------------------------------------- |
| h             | Di chuyển con trỏ sang trái một ký tự    |
| l             | Di chuyển con trỏ sang phải một ký tự   |
| j             | Di chuyển con trỏ xuống một dòng (dòng tiếp theo trong văn bản).    |
| k             | Di chuyển con trỏ lên một dòng (dòng trước đó trong văn bản).  |
| w             | Di chuyển con trỏ tiến lên một từ tới trước từ tiếp theo.    |
| e             | Di chuyển con trỏ đến cuối từ hiện tại.    |
| b             | Di chuyển con trỏ lùi lại một từ.  |
| ^             | Di chuyển con trỏ về đầu dòng.   |
| $             | Di chuyển con trỏ đến cuối dòng.   |
| gg            | Di chuyển con trỏ đến dòng đầu tiên của tập tin.   |
| G             | Di chuyển con trỏ đến dòng cuối cùng của tập tin.   |
| nG            | Di chuyển con trỏ đến dòng thứ n của tập tin. |
| Ctrl + B      | Cuộn lên gần như toàn màn hình. |
| Ctrl + F      | Cuộn xuống gần như toàn màn hình. |
| Ctrl + U      | Cuộn lên một nửa màn hình. |
| Ctrl + D      | Cuộn xuống một nửa màn hình. |
| Ctrl + Y      | Cuộn lên một dòng. |
| Ctrl + E      | Cuộn xuống một dòng. |

{{< alert type="info" >}}
Nếu bạn có một tệp văn bản lớn và cần tìm kiếm gì đó, cũng có các phím lệnh trong Command Mode để thực hiện tìm kiếm. Gõ `?` để bắt đầu tìm kiếm về phía trước hoặc `/` để tìm kiếm về phía sau. Phím lệnh này sẽ hiển thị ở cuối trình soạn thảo **vim** và cho phép bạn gõ văn bản gần tìm. Nếu mục đầu tiên tìm được không phải là những gì bạn cần, nhấn Enter, sau đó liên tục nhấn phím n để di chuyển đến mãu văn bản khớp tiếp theo.
{{< /alert >}}

Di chuyển nhanh chóng trong buffer area của vim rất hữu ích. Tuy nhiên cũng có một số lệnh chỉnh sửa giúp tăng tốc quá trình sửa đổi của bạn. Bảng 1.3 liệt kê các lệnh chỉnh sửa ở Editing Mode được sử dụng phổ biến hơn. Hãy chú ý đến cách viết hoa của từng chữ cái, vì tổ hợp phím viết thường thực hiện thao tác khác với chữ hoa. 

**TABLE 1.3**  Các command chỉnh sửa phổ biến trong `vim` ở Command Mode
| Keystroke(s)  | Descriptions |
| :------------ | :------------------------------------------------- |
| a             | Chèn văn bản sau con trỏ.    |
| A             | Chèn văn bản vào cuối dòng văn bản.   |
| dd            | Xoá dòng hiện tại.    |
| dw            | Xoá từ hiện tại.  |
| i             | Chèn văn bản trước con trỏ.    |
| l             | Chèn văn bản vào trước đầu dòng văn bản.    |
| o             | Mở dòng văn bản mới bên dưới con trỏ và chuyển sang chế độ chèn  |
| O             | Mở một dòng văn bản mới phía trên con trỏ và chuyển sang chế độ chèn.   |
| p             | Dán văn bản đã sao chép sau con trỏ.   |
| P             | Dán văn bản đã sao chép (yanked) trước con trỏ.   |
| yw            | Yank (sao chép) từ hiện tại.   |
| yy            | Yank (sao chép) dòng hiện tại. |

Ở Command Mode, bạn có tiến thêm một bước nữa bằng cách sử dụng các lệnh chỉnh sửa cú pháp như sau:

*COMMAND [ NUMBER-OF-TIMES ] ITEM*

Ví dụ, bạn muốn xoá ba từ, bạn sẽ nhấn các phím D, 3, và W. Nếu bạn muốn copy (yark) văn bản từ con trỏ đến cuối dòng văn bản, bạn sẽ nhấn các phím Y $, di chuyển đến vị trí bạn muốn dán văn bản và nhấn phím P.

{{< alert type="info" >}}
Tip: Hãy nhớ rằng chúng ta sẽ luôn ở **Command Mode**, di chuyển con trỏ đến nơi nó cần phải ở trong một tệp và sau đó nhấn phím `I` để chuyển sang **Insert Mode** để soạn thảo văn bản dễ dàng hơn. Đây là một trong những best practice để sử dụng vim.
{{< /alert >}}

Chế độ thứ ba là **Ex Mode**, có thêm các lệnh khác. Bạn phải ở **Command Mode** để vào **Ex Mode**. Bạn không thể chuyển từ **Insert Mode** sang **Ex Mode** được. Do đó nếu đang ở **Insert Mode**, hãy nhấn phím `Esc` để quay lại **Command Mode**.

Bảng 1.4 hiển thị một số command trong **Ex Mode** có thể giúp bạn quản lý tệp văn bản của mình. Để ý rằng tất cả các lần nhấn phím đều bao gồm dấu hai chấm (:) để sử dụng Ex commands.

**TABLE 1.4**  Các command phổ biến trong `vim` ở Ex Mode
| Keystroke(s)  | Descriptions |
| :------------ | :------------------------------------------------- |
| :! command    | Thực thi shell command và hiển thị kết quả nhưng không thoát khỏi trình soạn thảo.    |
| :r! command   | Thực thi shell command và đưa kết quả vào buffer area của trình soạn thảo.   |
| :r file       | Đọc nội dung tập tin và đưa chúng vào buffer area của trình soạn thảo.    |

## Lưu các thay đổi

Sau khi đã thực hiện các thay đổi cần thiết trong buffer area của vim, thì đã đến lúc lưu lại công việc. Bạn có thể sử dụng một trong nhiều cách ở trong bảng 1.5. Gõ ZZ trong Command Mode để ghi bộ đệm vào đĩa và thoát khỏi quá trình của bạn từ trình soạn thảo vim.

**TABLE 1.5**  Lưu lại thay đổi trong vim editor
| Mode    | Keystroke(s)  | Descriptions |
| :----   | :------------ | :------------------------------------------------- |
| Ex      | :x            | Ghi bộ đệm vào tập tin và thoát khỏi trình soạn thảo.    |
| Ex      | :wq           | Ghi bộ đệm vào tập tin và thoát khỏi trình soạn thảo.    |
| Ex      | :wq!          | Ghi bộ đệm vào tập tin và thoát khỏi trình soạn thảo (overrides protection - đây là một lệnh mạnh kiểu force).    |
| Ex      | :w            | Ghi bộ đệm vào tập tin và vẫn ở lại trình soạn thảo.    |
| Ex      | :w!           | Ghi bộ đệm vào tập tin và vẫn ở lại trình soạn thảo (overrides protection).    |
| Ex      | :q            | Thoát khỏi editor mà không lưu bộ đệm vào file.    |
| Ex      | :q!           | Thoát khỏi editor mà không lưu bộ đệm vào file (overrides protection).    |
| Command | ZZ            | Ghi bộ đệm vào tập tin và thoát khỏi trình soạn thảo.    |

Sau khi đã đi qua các command ở các chế độ khác nhau, bạn có thể hiểu tại sao một số người không thích trình soạn thảo `vim` vì nó có rất nhiều lệnh khó hiểu cần biết. Tuy nhiên một số người sẽ rất yêu thích trình soạn thảo `vim` vì nó thật sự mạnh mẽ.

Thật là thiếu sót khi chỉ học một trình soạn thảo văn bản và bỏ qua những trình soạn thảo văn bản khác. Biết ít nhất hai trình soạn thảo văn bản sẽ rất hữu ích trong công việc với Linux của bạn. Đối với các sửa đổi đơn giản, `nano` editor sẽ là ngôi sao toả sáng. Còn nếu để chỉnh sửa phức tạp hơn, các trình soạn thảo `vim` và `emacs` sẽ là ưu tiên hàng đầu. Tất cả đều đáng để bạn dành thời gian học và làm chủ các editor này.