---
title: "Chapter 3 - Functional Programming"
date: 2024-08-14T06:00:20+06:00
hero: /images/posts/terraform/chapter-2-hero.png
description: "Chapter 3 - Functional Programming"
menu:
  sidebar:
    name: "Chapter 3 - Functional Programming"
    identifier: chapter-3
    parent: terraform-in-action
    weight: 12
---

> Chương này bao gồm
> - Sử dụng các biến thế của *input variables*, *local values*, và *output values*
> - Sử dụng khả năng tính toán của Terraform với *functions* và *for expressions*
> - Tìm hiểu thêm về 2 provider: *Random* và *Archive*
> - Tạo các mẫu với *templatefile()*
> - Scaling resources với *count*


*Functional programming* là một mô hình lập trình khai báo cho phép bạn thực hiện nhiều việc chỉ bằng một dòng mã. Bằng cách soạn thảo các module function nhỏ, bạn có thể cho máy tính biết bạn muốn nó làm gì (what) thay vì thực hiện nó như thế nào (how). Các nguyên tắc cốt lõi của functional programming như sau:

- **Pure functions**: Với cùng một tập hợp các đầu vào, hàm sẽ luôn trả về cùng một kết quả. Điều này có nghĩa là kết quả của hàm chỉ phụ thuộc vào các tham số đầu vào, không phụ thuộc vào bất kỳ trạng thái bên ngoài nào. Không có side effect, tức là Pure functions không thực hiện bất kỳ thay đổi nào đối với trạng thái bên ngoài của ứng dụng, như thay đổi biến toàn cục, thay đổi bất kỳ đầu vào nào. 
- **First-class and higher-order functions**: Các hàm được xử lý giống như biến và có thể được lưu vào các biến khác, hoặc có thể nhận hàm khác làm tham số đầu vào hoặc trả về hàm khác làm kết quả.
- **Immutability** - Dữ liệu không bao giờ được sửa đổi trực tiếp. Thay vào đó, cấu trúc dữ liệu mới được tạo mỗi khi dữ liệu thay đổi

Để thấy được sự khác biệt giữa lập trình thủ tục (procedural programming) và lập trình hàm (functional programming), đây là một số mã javascript procedural programming nhân tất cả các số chẵn trong một mảng với 10 và cộng các kết quả lại với nhau:

```
const numList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let result = 0;
for (let i = 0; i < numList.length; i++) {
 if (numList[i] % 2 === 0) {
   result += (numList[i] * 10)
 }
}
```

Và đây là code tương tự được giải quyết bằng lập trình chức năng cũng với Javascript:

```
const numList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
const result = numList
              .filter(n => n % 2 === 0)
              .map(a => a * 10)
              .reduce((a, b) => a + b)
```

Và với Terraform: 

```
locals {
 numList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
 result  = sum([for x in local.numList : 10 * x if x % 2 == 0])
}
```

Mặc dù bạn có thể không coi mình là một lập trình viên, nhưng điều quan trọng là phải nắm được những kiến ​​thức cơ bản về lập trình chức năng (functional programming). Terraform không hỗ trợ trực tiếp lập trình thủ tục, vì vậy bất kỳ logic nào bạn muốn diễn đạt đều cần phải mang tính declarative và functional. Trong chương này, chúng ta đi sâu vào các hàm, biểu thức, mẫu và các tính năng khác tạo nên Terraform.

## 3.1 Fun with Mad Libs

Chúng ta sẽ xem xét xây dựng một chương trình tạo các đoạn Mad Libs từ các tệp mẫu. Trong trường hợp bạn chưa biết, Mad Libs là một trò chơi từ ngữ khá phổ biến, đặc biệt là với trẻ em. Trò chơi này hoạt động theo cách sau:
- Một người sẽ yêu cầu người khác cung cấp một số từ ngữ đặc biệt, chẳng hạn như danh từ, động từ, tính từ, không cho biết câu chuyện sẽ như thế nào.
- Sau khi người chơi cung cấp các từ ngữ, người chơi đầu tiên sẽ điền các từ đó vào một câu chuyện hoặc đoạn văn đã được chuẩn bị trước, nhưng bỏ trống một số chỗ.
- Kết quả là một câu chuyện hoàn chỉnh, thường mang tính hài hước và bất ngờ, bởi vì các từ được điền vào thường không liên quan gì đến nội dung câu chuyện.

Ví dụ:

> To make a pizza, you need to take a lump of <noun> and make a thin, round, <adjective> <noun>.

Đối với chuỗi mẫu đã cho, một danh từ ngẫu nhiên, một tính từ và một danh từ khác sẽ được chọn để điền vào chỗ trống.

> To make a pizza, you need to take a lump of **roles** and make a thin, round, **coloful jewelry**.

Hãy bắt đầu bằng cách tạo một câu chuyện Mad Libs. Để làm điều đó, chúng ta cần một nhóm từ ngẫu nhiên để chọn và một tệp mẫu. Nội dung được hiển thị sau đó sẽ được in ra CLI. Sơ đồ kiến ​​trúc cho những gì chúng ta sắp làm được hiển thị trong Hình 3.1

**Hình 3.1** Architecture diagram of the Mad Libs template engine
{{<img src="/assets/images/posts/terraform/figure3.1.png" align="left" title="Architecture diagram of the Mad Libs template engine" >}}

### 3.1.1 Input variables

Đầu tiên, chúng ta cần tạo một nhóm từ. Điều đó có nghĩa là chúng ta cần nói về **input variables** - chúng là gì, chúng được khai báo như thế nào cũng như cách chúng có thể được thiết lập và validate.

*Input variables* (hoặc là *Terraform variables* hoặc đơn giản chỉ là *variables*) là các giá trị do người dùng cung cấp để tham số hóa mô-đun Terraform mà không làm thay đổi mã nguồn. 

- **Parametrize Module**: Input Variables cho phép bạn tham số hóa các module Terraform, đồng nghĩa với việc bạn có thể sử dụng lại cùng một module với các giá trị đầu vào khác nhau mà không cần thay đổi mã nguồn.
- **User-supplied Values**: Các giá trị cho Input Variables sẽ được người dùng cung cấp khi sử dụng module, thay vì được định nghĩa cứng trong mã nguồn.
- **Không thay đổi mã nguồn**: Việc thay đổi các giá trị đầu vào không ảnh hưởng đến mã nguồn của module, cho phép module có thể được sử dụng trong nhiều bối cảnh khác nhau.

Variable được được khai báo bằng variable block - là một HCL object có 2 label. Label thứ nhất laf object type `variable`, label thứ 2 là tên của biến (variable's name). Bạn có thể đặt tên tuỳ ý, miễn là tên này nó phải là duy nhất trong module và không phải là các định danh dành riêng cho các element trong terraform như : "resource", "provider", "module",... Hình 3.2 mô tả cú pháp của một variable block

**Hình 3.2** Cú pháp của variable
{{<img src="/assets/images/posts/terraform/figure3.2.png" align="left" title="Cú pháp của variable" >}}

Variable block có bốn đối số đầu vào (input arguments) đó là:
- **default**: giá trị mặc định khi không có giá trị nào được truyền vào. Nếu để đối số này trống thì có nghĩa là variable này là bắt buộc và phải có giá trị rõ ràng.
- **description**: giá trị string để cung cấp các thông tin mô tả, giúp cho người dùng có thể biết được thêm thông tin của biến này.
- **type**: Kiểu dữ liệu của variable. Có thể là kiểu nguyên thủy (ví dụ: string, integer, bool) hoặc kiểu phức tạp (ví dụ: list, set, map, object, tuple).
- **validation**:  Một nested object có thể thực thi các quy tắc xác thực tuỳ chỉnh.

{{< alert type="info" >}}
Bạn có thể truy cập các giá trị biến trong một mô-đun nhất định bằng cách sử dụng biểu thức var.<VARIABLE_NAME>. Ví dụ var.noun
{{< /alert >}}

Trong bài viết này, chúng ta có thể xác định các biến riêng cho từng loại từ cho trò chơi Mad Libs. Ví dụ danh từ, tính từ, động từ, ... Code sẽ như sau:
```
variable "nouns" {
 description = "A list of nouns"
 type        = list(string)
}

variable "adjectives" {
 description = "A list of adjectives"
 type        = list(string)
}

variable "verbs" {
 description = "A list of verbs"
 type        = list(string)
}

variable "adverbs" {
 description = "A list of adverbs"
 type        = list(string)
}

variable "numbers" {
 description = "A list of numbers"
 type        = list(number)
}
```

Mặc dùng đoạn code trên khá rõ ràng, tuy nhiên chúng ta sẽ nhóm các variable lại với nhau thành một variable phức tạp hơn (để có thể sử dụng biểu thức `for` để lặp qua các từ).

Tạo project mới vaf tạo một tệp mới có tên madlibs.tf. Nội dụng file sẽ như sau

**Listing 3.1** madlibs.tf
```
terraform {
  required_version = ">= 0.15"
}
 
variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({
    nouns      = list(string),
    adjectives = list(string),
    verbs      = list(string),
    adverbs    = list(string),
    numbers    = list(number),
  })
}
```

{{< alert type="info" >}}
**Ép kiểu (type coercion)**
Object có key là **numbers** trong var.words có thể là list(string) thay vì list(number) do được ép kiểu. Ép kiểu là khả năng chuyển đổi bất kỳ kiểu nguyên thủy nào trong Terraform thành dạng chuỗi của nó. Ví dụ: boolean `true` và `false` được chuyển đổi thành `"true"` và `"false"`, trong khi các số được chuyển đổi tương tự (ví dụ: 17 thành "17").
Cần chú ý về việc ép kiểu để biết được giá trị thực sự của một biến, việc vô tình không nắm rõ được cơ chế ép kiểu sẽ dẫn đến kết quả tính toán sai. Ví dụ: biểu thức 17=="17" sẽ trả về kết quả là `false` thay vì `true`.
{{< /alert >}}

### 3.1.2 Gán giá trị cho variable bằng file tfvars

Việc gán các giá trị biến với đối số `default` không phải là một ý tưởng hay vì làm như vậy không tạo điều kiện cho việc tái sử dụng lại mã. Cách tốt hơn để đặt giá trị cho biến đó là sử dụng file để định nghĩa biến (variables definition file), đó là bất kỳ file nào có đuôi là `.tfvars` hoặc `.tfvars.json`. Variables definition file sử dụng cú pháp tương tự như cú pháp của Terraform configuration, tuy nhiên chỉ bao gồm các phép gán biến.

Tạo một tệp mới trong không gian làm việc của bạn với tên là *terraform.tfvars* và thêm code dưới đây:

**Listing 3.2** terraform.tfvars
```
words = {
  nouns      = ["army", "panther", "walnuts", "sandwich", "Zeus", "banana", "cat", "jellyfish", "jigsaw", "violin", "milk", "sun"]
  adjectives = ["bitter", "sticky", "thundering", "abundant", "chubby", "grumpy"]
  verbs      = ["run", "dance", "love", "respect", "kicked", "baked"]
  adverbs    = ["delicately", "beautifully", "quickly", "truthfully", "wearily"]
  numbers    = [42, 27, 101, 73, -5, 0]
}
```

### 3.1.3 Validating variables

Các biến có thể được validate với các quy tắc tuỳ chỉnh bằng cách khai báo các nested block là `validation`. 

Ví dụ, để validate có ít nhất 20 danh từ được truyền vào `var.words`, bạn có thể viết một `validation` block như sau:

```
variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({
    nouns      = list(string),
    adjectives = list(string),
    verbs      = list(string),
    adverbs    = list(string),
    numbers    = list(number),
  })
 
  validation {
    condition     = length(var.words["nouns"]) >= 20
    error_message = "At least 20 nouns must be supplied."
  }
}
```

Đối số `condition` trong validation block là một biểu thức xác định xem một biến đó có hợp lệ hay không. `true` có nghĩa là hợp lệ, trong khi `false` có nghĩa là không hợp lệ. Các biểu thức không hợp lệ sẽ xuất hiện lỗi và thông báo lỗi `error_message` sẽ được hiển thị cho người dùng. Đây là một ví dụ khi biến không hợp lệ:
```
│
│  Error: Invalid value for variable
│  
│    on madlibs.tf line 5:
│     5: variable "words" {
│  
│  At least 20 nouns must be supplied.
│  
│  This was checked by the validation rule at madlibs.tf:14,1-11.
```

{{< alert type="info" >}}
**TIP**:  Không có giới hạn về số lượng `validation` block mà bạn có thể có trên một biến.
{{< /alert >}}

### 3.1.4  Xáo trộn danh sách

Bây giờ chúng ta đã có các từ trong nhóm từ của mình, bước tiếp theo là xáo trộng chúng. Nếu chúng ta không xáo trộng các danh sách này thì thứ tự của các từ sẽ được cố định, như vậy có nghĩa là các đoạn Mad Libs giống nhau sẽ được tạo ra mỗi lần thực thi. Không ai muốn độc đi đọc lại một câu chuyện Mad Libs cả. Tới đây, bạn có thể đang mong chờ một hàm đại loại như là `shuffle()` để có thể xáo trộng một danh sách, nhưng thực tế thì chúng ta không có. Bời vì Terraform là functional programming language, có nghĩa là tất cả các hàm đều là pure function (trả về cũng một kết quả cho một tập hợp các đối số đầu vào nhất định).

{{< alert type="info" >}}
`uuid()` và `timestamp()` là 2 hàm duy nhất không phải là pure function trong Terraform. Đây là những hàm cũ nên tránh bất cứ khi nào có thể vì chúng có khả năng gây ra các lỗi và vì chúng có thể không được dùng nữa (cho tới hiện tại thì vẫn còn được sử dụng).
{{< /alert >}}

**Random** provider trong Terraform cho phép xáo trộn các list một cách an toàn bằng **random_shuffle** resource. Chúng ta có 5 list (nouns, adjectives, verbs, adverbs, numbers) cho nên sẽ cần 5 danh sách ngẫu nhiên. Mô tả ở hình 3.3

**Hình 3.3** Xáo trộn list các string trong var.words
{{<img src="/assets/images/posts/terraform/figure3.3.png" align="left" title="Xáo trộn list các string trong var.words" >}}

Dán code bên dưới vào file madlibs.tf để xáo trộn các từ.

**Listing 3.3** madlibs.tf
```
terraform {
  required_version = ">= 0.15"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
 
variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({
    nouns      = list(string),
    adjectives = list(string),
    verbs      = list(string),
    adverbs    = list(string),
    numbers    = list(number),
  })
}
 
resource "random_shuffle" "random_nouns" {
  input = var.words["nouns"]
}
 
resource "random_shuffle" "random_adjectives" {
  input = var.words["adjectives"]
}
 
resource "random_shuffle" "random_verbs" {
  input = var.words["verbs"]
}
 
resource "random_shuffle" "random_adverbs" {
  input = var.words["adverbs"]
}
 
resource "random_shuffle" "random_numbers" {
  input = var.words["numbers"]
}
```

### 3.1.5 Functions

Chúng ta sẽ sử dụng danh sách các từ ngẫu nhiên để điền vào chỗ trống trong trò chơi Mad Libs, hiển thị nội dung cho câu chuyện Mad Libs mới `templatefile()` function tích hợp sẵn cho phép chúng ta thực hiện việc này một cách dễ dàng. Các hàm Terraform là các biểu thức biến đổi đầu vào thành đầu ra. Không giống như các ngôn ngữ lập trình khác, Terraform không hỗ trợ các hàm do người dùng xác định và cũng không có cách nào để import các hàm từ các thư viện bên ngoài. Thay vào đó, bạn bị giới hạn ở khoảng 100 hàm được tích hợp trong ngôn ngữ Terraform. Con số này là rất nhiều đối với một ngôn ngữ lập trình khai báo nhưng hầu như không là gì so với các ngôn ngữ lập trình truyền thống.

{{< alert type="info" >}}
Chúng ta có thể mở rộng Terraform bằng cách tạo ra provider của riêng mình, chứ không tạo functions mới được
{{< /alert >}}

Hình 3.4 sẽ cho chúng ta biết về cú pháp của `templatefile()`:

**Hình 3.4** Cú pháp của templatefile()
{{<img src="/assets/images/posts/terraform/figure3.4.png" align="left" title="Cú pháp của templatefile()" >}}

Trong hình trên, chúng ta thấy rằng `templatefile()` nhận vào 2 đối số: path của templatefile và 1 map các template variable (dạng object). Chúng tôi sẽ xây dựng một map các biến template bằng cách kết hợp danh sách các từ được xáo trộn lại với nhau như hình 3.5

**Hình 3.5** Kết hợp các danh sách các từ đã được xáo trộn để tạo một map các biến của template
{{<img src="/assets/images/posts/terraform/figure3.5.png" align="left" title="Kết hợp các danh sách các từ đã được xáo trộn để tạo một map các biến của template" >}}

Và đây là `templatefile()` code:
```
templatefile("${path.module}/templates/alice.txt",
   {
       nouns=random_shuffle.random_nouns.result
       adjectives=random_shuffle.random_adjectives.result
       verbs=random_shuffle.random_verbs.result
       adverbs=random_shuffle.random_adverbs.result
       numbers=random_shuffle.random_numbers.result
   })
```

### 3.1.6 Output values

Chúng ta có thể trả về kết quả của hàm `templatefile()` cho user với output value. Output value là các giá trị dùng để làm 2 điều sau:
- Truyền các giá trị giữa các module với nhau.
- In các giá trị ra command line interface

Chúng ta sẽ thảo luận về việc truyền giá trị giữa các module ở [Chương 4](), còn ở hiện tại, chúng ta sẽ nói về việc in giá trị ra màn hình CLI. Cú pháp của một `output` block như hình 3.6

**Hình 3.6** Cú pháp của output block
{{<img src="/assets/images/posts/terraform/figure3.6.png" align="left" title="Cú pháp của output block" >}}

Hãy thêm `output` block vào file madlibs.tf. Cấu hình của bạn bây giờ sẽ như sau:

**Listing 3.4** madlibs.tf
```
terraform {
 required_version = ">= 0.15"
 required_providers {
   random = {
     source  = "hashicorp/random"
     version = "~> 3.0"
   }
 }
}

variable "words" {
 description = "A word pool to use for Mad Libs"
 type = object({
   nouns      = list(string),
   adjectives = list(string),
   verbs      = list(string),
   adverbs    = list(string),
   numbers    = list(number),
 })
}

resource "random_shuffle" "random_nouns" {
 input = var.words["nouns"]
}

resource "random_shuffle" "random_adjectives" {
 input = var.words["adjectives"]
}

resource "random_shuffle" "random_verbs" {
 input = var.words["verbs"]
}

resource "random_shuffle" "random_adverbs" {
 input = var.words["adverbs"]
}

resource "random_shuffle" "random_numbers" {
 input = var.words["numbers"]
}

output "mad_libs" {
 value = templatefile("${path.module}/templates/alice.txt",
   {
     nouns      = random_shuffle.random_nouns.result
     adjectives = random_shuffle.random_adjectives.result
     verbs      = random_shuffle.random_verbs.result
     adverbs    = random_shuffle.random_adverbs.result
     numbers    = random_shuffle.random_numbers.result
 })
}
```

{{< alert type="info" >}}
**NOTE**: `path.module` là đường dẫn tham chiếu đến filesystem path của module hiện tại.
{{< /alert >}}

### 3.1.7 Templates

Và điều cuối cùng chúng ta làm để có thể xong trò chơi Mad Libs này đó là tạo 1 tempalte file có tên là *alice.txt*. 

Cú pháp template cũng giống với các giá trị nội suy trong ngôn ngữ Terraform (interpolation - thay thế biến), là bất kỳ thứ gì được đặt trong dấu ${...}. 

Hãy tạo template file ngay bây giờ. Đầu tiên, tạo một thư mục mới có tên là `templates` để chứa các tệp mẫu; trong thư mục này, tạo một tệp **alice.txt**.

**Listring 3.5** alice.txt
```
ALICE'S UPSIDE-DOWN WORLD

Lewis Carroll's classic, "Alice's Adventures in Wonderland", as well
as its ${adjectives[0]} sequel, "Through the Looking ${nouns[0]}",
have enchanted both the young and old ${nouns[1]}s for the last
${numbers[0]} years, Alice's ${adjectives[1]} adventures begin
when she ${verbs[0]}s down a/an ${adjectives[2]} hole and lands
in a strange and topsy-turvy ${nouns[2]}. There she discovers she
can become a tall ${nouns[3]} or a small ${nouns[4]} simply by
nibbling on alternate sides of a magic ${nouns[5]}. In her travels
through Wonderland, Alice ${verbs[1]}s such remarkable
characters as the White ${nouns[6]}, the ${adjectives[3]} Hatter,
the Cheshire ${nouns[7]}, and even the Queen of ${nouns[8]}s.
Unfortunately, Alice's adventures come to a/an ${adjectives[4]}
end when Alice awakens from her ${nouns[8]}.
```

### 3.1.8 In output ra CLI

Cuối cùng chúng ta đã sẵn sàng tạo đoạn Mad Libs đầu tiên. Khởi tạo Terraform bằng `terrafrom init` và sau đó apply.
```
$ terraform init && terraform apply -auto-approve
...
random_shuffle.random_adjectives: Creation complete after 0s [id=-]
random_shuffle.random_numbers: Creation complete after 0s [id=-]
random_shuffle.random_nouns: Creation complete after 0s [id=-]
 
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
 
Outputs:
 
mad_libs = <<EOT
ALICE'S UPSIDE-DOWN WORLD
 
Lewis Carroll's classic, "Alice's Adventures in Wonderland", as well
as its chubby sequel, "Through the Looking sun",
have enchanted both the young and old panthers for the last
0 years, Alice's bitter adventures begin
when she kickeds down a/an thundering hole and lands
in a strange and topsy-turvy army. There she discovers she
can become a tall banana or a small jigsaw simply by
nibbling on alternate sides of a magic Zeus. In her travels
through Wonderland, Alice respects such remarkable
characters as the White walnuts, the sticky Hatter,
the Cheshire milk, and even the Queen of violins.
Unfortunately, Alice's adventures come to a/an abundant
end when Alice awakens from her violin.
 
EOT
```

## 3.2 Tạo thêm nhiều Mad Libs Strory

Chúng ta có thể tạo một câu chuyện Mad Libs từ một nhóm từ ngẫu nhiên và xuất kết quả ra CLI. Nhưng điều gì sẽ xảy ra nếu chúng ta muốn tạo ra nhiều Mad Libs cùng một lúc? Thật dễ dàng để thực hiện bằng cách sử dụng các biểu thức và đối số `count`. Các công việc sẽ làm ở mục này như sau:

1. Tạo 100 đoạn Mad Libs
2. Dùng 3 template file (alice.txt, observatory.txt và photographer.txt)
3. Viết hoa tất cả các từ trước khi xáo trộn với nhau
4. Lưu các đoạn Mad Libs vào text file
5. Nén tât cả chúng lại dưới định dạng ZIP

Kiến trúc của chúng ta sẽ như hình 3.7:

**Hình 3.7** Tạo nhiều đoạn Mad Libs hơn
{{<img src="/assets/images/posts/terraform/figure3.7.png" align="center" title="Tạo nhiều đoạn Mad Libs hơn" >}}

### 3.2.1 Biểu thức for

Chúng ta có thêm một bước là viết hoa tất cả các chuỗi trong *var.words* trước khi xáo trộn. Điều này không thực sự cần thiết nhưng nó giúp bạn dễ dàng xem các từ và nắm được kiến thức về `for`. Kết quả của hàm viết hoa được lưu vào một local value, sau đó được đưa vào random_shuffle.

Để viết hoa tất cả các chuỗi trong *var.words*, chúng ta cần sử dụng biểu thức `for`. `for` là anonymous function có thể biến đổi một kiểu dữ liệu phức tạp thành một kiểu khác. Hình 3.8 mô tả cú pháp của `for` expression để viết hoa các phần tử trong một mảng các string, và output là một mảng mới. Hình 3.9 minh hoạ cho quá trình xử lý.

**Hình 3.8** Cú pháp của `for` expression để viết hoa mỗi từ trong một mảng
{{<img src="/assets/images/posts/terraform/figure3.8.png" align="center" title="Cú pháp của for expression để viết hoa mỗi từ trong một mảng" >}}

**Hình 3.9** Minh hoạ quá trình xử lý của `for` expression của hình 3.8
{{<img src="/assets/images/posts/terraform/figure3.9.png" align="center" title="Minh hoạ quá trình xử lý của for expression của hình 3.8" >}}

Dấu ngoặc vuông bọc `for` expression xác định kiểu dữ liệu đầu ra (output type). Chúng ta đang sử dụng `[]`, có nghĩa là output sẽ là một list. Nếu chúng ta sử dụng `{}`, thì kết quả sẽ là một object. Một ví dụ khác, nếu bạn muốn lặp qua *var.words* và output ra một `map` mới có cùng key với `map` ban đầu và giá trị là độ dài của giá trị ban đầu, chúng ta có thể làm điều đó với biểu thức được mô tả trong hình 3.10 và 3.11 như sau

**Hình 3.10** Cú pháp sử dụng for expression để lặp qua var.words và output ra một map mới
{{<img src="/assets/images/posts/terraform/figure3.10.png" align="center" title="Cú pháp sử dụng for expression để lặp qua var.words và output ra một map mới" >}}

**Hình 3.11** Minh hoạ quá trình xử lý của `for` expression của hình 3.10
{{<img src="/assets/images/posts/terraform/figure3.11.png" align="center" title="Minh hoạ quá trình xử lý của for expression của hình 3.10" >}}

`for` expression rất hữu ích vì chúng có thể chuyển đổi dữ liệu từ kiểu này này sang kiểu khác khác và vì các biểu thức đơn giản nên nó có thể được kết hợp để xây dựng hàm bậc cao . Để tạo một vòng `for` viết hoa mỗi từ trong *var.words*, chúng ta sẽ kết hợp hai biểu thức `for` nhỏ hơn thành một biểu thức `for` lớn.

{{< alert type="info" >}}
**TIP**: Các biểu thức `for` lồng nhau sẽ làm ảnh hưởng đến khả năng đọc và làm tăng độ phức tạp khi số lượng phần tử tăng lên, vì vậy hãy cố gắng đừng lạm dụng chúng.
{{< /alert >}}

Để có thể viết hoa tất cả các từ trong var.words thì sẽ có những bước cơ bản sau:
1. Lặp qua từng cặp key-value trong *var.words*.
2. Viết hoa mỗi từ trong danh sách của value.
3. Lưu kết quả vào local value.

Việc lặp qua từng cặp khóa-giá trị trong *var.words* và xuất ra một `map` mới có thể được thực hiện bằng biểu thức sau:
```
{for k,v in var.words : k => v }
```

Biểu thức tiếp theo là viết hoa mỗi từ trong một danh sách và xuất ra một danh sách mới:
```
[for s in v : upper(s)]
```

Kết hợp 2 biểu thức này chúng ta có:
```
{for k,v in var.words : k => [for s in v : upper(s)]}
```

Ngoài ra, nếu bạn muốn lọc một key cụ thể, bạn có thể sử dụng mệnh đề `if`. Ví dụ: muốn không lặp qua 'numbers', bạn có thể thực hiện bằng biểu thức sau:
```
{for k,v in var.words : k => [for s in v : upper(s)] if k != "numbers"}
```

### 3.2.2 Local values

Chúng ta có thể lưu kết quả của một biểu thức bằng việc gán giá trị đó cho một `local` value. Local values trong Terraform cho phép bạn gán một tên cho một biểu thức, sau đó sử dụng lại biểu thức này nhiều lần mà không cần phải lặp lại nó. Điều này rất hữu ích khi bạn có một biểu thức phức tạp hoặc một giá trị được sử dụng ở nhiều nơi trong mã Terraform của bạn. Local values trong Terraform tương tự như các biến tạm thời được định nghĩa trong các ngôn ngữ lập trình truyền thống.

Local values được khai báo bằng một code block có label là `locals`. Cú pháp của `locals` block được mô tả ở hình 3.12

**Hình 3.12** Cú pháp của local value
{{<img src="/assets/images/posts/terraform/figure3.12.png" align="left" title="Cú pháp của local value" >}}

Thêm một local value trong file madlib.tf, và update các tham chiếu của random_shuffle để trỏ tới local.uppercase_words thay vì var.words

**Listing 3.6** madlibs.tf
```
terraform {
  required_version = ">= 0.15"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}
 
variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({
    nouns      = list(string),
    adjectives = list(string),
    verbs      = list(string),
    adverbs    = list(string),
    numbers    = list(number),
  })
}
 
locals {
  uppercase_words = {for k, v in var.words : k => [for s in v : upper(s)]}
}
 
resource "random_shuffle" "random_nouns" {
  input = local.uppercase_words["nouns"]
}
 
resource "random_shuffle" "random_adjectives" {
  input = local.uppercase_words["adjectives"]
}
 
resource "random_shuffle" "random_verbs" {
  input = local.uppercase_words["verbs"]
}
 
resource "random_shuffle" "random_adverbs" {
  input = local.uppercase_words["adverbs"]
}
 
resource "random_shuffle" "random_numbers" {
  input = local.uppercase_words["numbers"]
}
```

### 3.2.3 Implicit dependencies

Khi bạn sử dụng một giá trị nội suy (interpolated value) để làm input argument cho tài nguyên random_shuffle, Terraform sẽ tạo ra một sự phụ thuộc ngầm định giữa hai tài nguyên này.

**Hình 3.13** Sử dụng count để tạo danh sách các tài nguyên có thể được tham chiếu bằng số thứ tự
{{<img src="/assets/images/posts/terraform/figure3.13.png" align="center" title="Phụ thuộc ngầm định của các tài nguyên " >}}

Các node ở cuối biểu đồ phụ thuộc (dependency graph) có ít phần phụ thuộc hơn, trong khi các node ở phía trên có nhiều phần phụ thuộc hơn. Ở trên cùng là root node, phụ thuộc vào tất cả các node khác. 
Bạn cần biết những điều sau đây về dependency graph:
- Phụ thuộc một cách vòng tròn là không được cho phép trong Terraform
- Các node mà không phụ thuộc vào các node khác sẽ được tạo đầu tiên, và được destroy sau cùng (created first and destroyed last)
- Terraform không đảm bảo thứ tự thực hiện giữa các node (tài nguyên) cùng cấp độ phụ thuộc. (Để giải quyết vấn đề này, bạn có thể sử dụng các tùy chọn như depends_on hoặc depends_on_id để xác định rõ ràng các mối quan hệ phụ thuộc. Điều này sẽ giúp Terraform hiểu được thứ tự triển khai mà bạn mong muốn)

### count parameter

Để tạo ra 100 Mad Libs story, một cách tối kiến là sao chép mã của chúng ta 100 lần và chạy nó. Tuy nhiên đây là một cách không hay và trông không chuyên nghiệp. May mắn thay, chúng ta có các tùy chọn tốt hơn cho công việc này, đó là sử dụng meta argument là `count` để cung cấp tài nguyên một cách dynamic.

{{< alert type="info" >}}
**NOTE**: Ở [Chapter 7]() chúng ta sẽ học về `for_each`, đó là một cách để thay thế `count`
{{< /alert >}}

`count` là một *meta argument*, hầu hết các resource của Terraform đều hỗ trợ count. Terraform sử dụng định dạng <RESOURCE_TYPE>.<NAME> để tham chiếu đến địa chỉ của một tài nguyên quản lý. Nếu `count` được thiết lập cho một tài nguyên, giá trị của biểu thức này sẽ trở thành một danh sách các đối tượng đại diện cho tất cả các instances của tài nguyên đó. Vì vậy, bạn có thể truy cập vào thể hiện thứ N trong danh sách bằng cách sử dụng cú pháp truy cập phần tử bằng chỉ số: <RESOURCE_TYPE>.<NAME>.[N].

Ví dụ, nếu bạn có một tài nguyên aws_instance với count = 3, bạn có thể truy cập vào:
- Instance đầu tiên: aws_instance.example[0]
- Instance thứ hai: aws_instance.example[1]
- Instance thứ ba: aws_instance.example[2]

**Hình 3.14** Sử dụng count để tạo danh sách các tài nguyên có thể được tham chiếu bằng số thứ tự
{{<img src="/assets/images/posts/terraform/figure3.14.png" align="center" title="Sử dụng count để tạo danh sách các tài nguyên có thể được tham chiếu bằng số thứ tự" >}}

Hãy cập nhật mã của bạn để hỗ trợ tạo số lượng Mad Libs story tùy ý. Đầu tiên, thêm một biến mới có tên var.num_files có kiểu `number` và giá trị mặc định là 100. Tiếp theo, tham chiếu biến này để tự động đặt đối số `count` trên mỗi shuffle_resource.

**Listing 3.7** madlibs.tf
```
variable "words" {
  description = "A word pool to use for Mad Libs"
  type = object({
    nouns      = list(string),
    adjectives = list(string),
    verbs      = list(string),
    adverbs    = list(string),
    numbers    = list(number),
  })
}
 
variable "num_files" {
    default = 100
    type    = number
}
 
locals {
  uppercase_words = {for k,v in var.words : k => [for s in v : upper(s)]}
}
 
resource "random_shuffle" "random_nouns" {
  count = var.num_files
  input = local.uppercase_words["nouns"]
}
 
resource "random_shuffle" "random_adjectives" {
  count = var.num_files
  input = local.uppercase_words["adjectives"]
}
 
resource "random_shuffle" "random_verbs" {
    count = var.num_files
    input = local.uppercase_words["verbs"]
}
 
resource "random_shuffle" "random_adverbs" {
  count = var.num_files
input = local.uppercase_words["adverbs"]
}
 
resource "random_shuffle" "random_numbers" {
  count = var.num_files
  input = local.uppercase_words["numbers"]
}
```

### 3.2.5 Conditional expressions

Biểu thức có điều kiện (conditional expression) trong Terraform, còn được gọi là "toán tử ba ngôi", có thể được sử dụng để chọn giá trị của 1 trong 2 biểu thức: biểu thức thứ nhất khi điều kiện true và biểu thức thứ hai khi điều kiện false.

**Hình 3.15** Cú pháp của conditional expressions (hay còn gọi là toán tử 3 ngôi)
{{<img src="/assets/images/posts/terraform/figure3.15.png" align="center" title="Cú pháp của conditional expressions (hay còn gọi là toán tử 3 ngôi)" >}}

Trước khi `validation blocks` được giới thiệu trong Terraform, conditional expressions thường được sử dụng để xác thực các biến đầu vào. Điều này cho phép thực hiện logic xác thực phức tạp hơn so với các quy tắc xác thực đơn giản có sẵn. Tuy nhiên, với sự bổ sung của validation blocks, conditional expressions giờ đây chỉ đóng một vai trò nhỏ trong Terraform.

Đoạn code dưới đây minh hoạ việc sử dụng toán tử ba ngôi để validate ít nhất có 1 từ trong list `nouns` của `var.words`. Nếu điều kiện sai, lỗi sẽ xảy ra.

```
locals {
    v = length(var.words["nouns"])>=1 ? var.words["nouns"] : [][0]
}
```

Nếu *var.words["nouns"]* chứa ít nhất 1 từ thì ứng dụng sẽ tiếp tục một cách bình thường. Còn nếu không có từ nào thì lỗi sẽ xảy ra:
```
Error: Invalid index
 
  on main.tf line 8, in locals:
   8:     v = length(var.words["nouns"])>=1 ? var.words["nouns"] : [][0]
```

### 3.2.6 Local file

Thay vì xuất output ra CLI, chúng ta sẽ lưu kết quả vào máy với `local_file` resource. Đầu tiên chúng a cần đọc tất cả các tệp văn bản từ thư mục templates vào một list. Điều này có thể thực hiện với built-in function là fileset():

```
locals {
 templates = tolist(fileset(path.module, "templates/*.txt"))
}
```

{{< alert type="info" >}}
`set` và `list` trông giống nhau nhưng được coi là 2 kiểu dữ liệu khác nhau, do đó, cần chuyển đổi `set` thành `list` bằng tolist() để code hoạt động đúng.
{{< /alert >}}

Một khi chúng ta đã có list của template file, chúng ta có thể đưa kết quả vào `local_file`. tài nguyên này tạo ra 100 tệp văn bảng (giá trị 100 từ var.num_files):

```
resource "local_file" "mad_libs" {
 count    = var.num_files
 filename = "madlibs/madlibs-${count.index}.txt"
 content  = templatefile(element(local.templates, count.index),
   {
     nouns      = random_shuffle.random_nouns[count.index].result
     adjectives = random_shuffle.random_adjectives[count.index].result
     verbs      = random_shuffle.random_verbs[count.index].result
     adverbs    = random_shuffle.random_adverbs[count.index].result
     numbers    = random_shuffle.random_numbers[count.index].result
 })
}
```

Có hai điều đáng mới đáng nói ở đoạn code trên là `element()` và c`ount.index`. Hàm `element()` hoạt động trên một list như thể nó là một vòng tròn, truy xuất các phần tử ở một chỉ mục nhất định mà không đi ra ngoài giới hạn. Điều này có nghĩa là element() sẽ chia 100 câu chuyện Mad Libs cho 2 template.

Trong Terraform, hàm element() rất hữu ích khi bạn cần truy cập các phần tử trong một danh sách, tuple hoặc set mà không phải lo lắng về việc vượt quá giới hạn của danh sách.

Cú pháp của hàm element() như sau:

```
element(list, index)
```

Trong đó: 
- list: list , tuple hoặc set mà bạn muốn truy cập các phần tử.
- index: Chỉ số của phần tử mà bạn muốn lấy. Nếu chỉ số vượt quá giới hạn của danh sách, element() sẽ tự động quay lại từ đầu danh sách.

`count.index` tham chiếu đến chỉ mục (index) hiện tại của resource. Chúng ta sử dụng nó để tham số hóa tên tệp và đảm bảo rằng templatefile() nhận các biến từ tài nguyên `random_shuffle` tương ứng.


**Hình 3.16** random_nouns và mad_libs là list resource và phải được đồng bộ hóa với nhau
{{<img src="/assets/images/posts/terraform/figure3.16.png" align="center" title="random_nouns và mad_libs là list resource và phải được đồng bộ hóa với nhau" >}}

### 3.2.7 Zipping files

Trong Terraform, bạn có thể sử dụng tài nguyên archive_file để nén các tệp tin thành một tệp lưu trữ như ZIP, TAR, hoặc TGZ. Đây là một cách hữu ích để đóng gói các tệp tin liên quan vào một tệp duy nhất, có thể được sử dụng cho nhiều mục đích như lưu trữ, triển khai, hoặc chia sẻ.

Thêm đoạn code sau vào madlibs.tf:
```
data "archive_file" "mad_libs" {
 depends_on  = [local_file.mad_libs]
 type        = "zip"
 source_dir  = "${path.module}/madlibs"
 output_path = "${path.cwd}/madlibs.zip"
}
```

Meta argument `depends_on` chỉ định sự phụ thuộc rõ ràng (explicit dependencies) giữa các tài nguyên. `depends_on` được đưa vào đây vì `archive_file` phải được tạo sau khi tất cả các đoạn Mad Libs đã được tạo; nếu không, nó sẽ nén các tập tin vào một thư mục trống. Thông thường, chúng tôi sẽ thể hiện mối quan hệ này thông qua implicit dependencies bằng cách sử dụng input argument là một tài nguyên khác, nhưng archive_file thì không có input argument nào có thể implicit dependencies được, thay vào đó, chúng ta buộc phải sử dụng một `depends_on`.

Rồi, cuối cùng thì chúng ta sẽ có một file madlibs.tf hoàn chỉnh như sau:
**Listing 3.10** madlibs.tf
```
terraform {
 required_version = ">= 0.15"
 required_providers {
   random = {
     source  = "hashicorp/random"
     version = "~> 3.0"
   }
   local = {
     source  = "hashicorp/local"
     version = "~> 2.0"
   }
   archive = {
     source  = "hashicorp/archive"
     version = "~> 2.0"
   }
 }
}
variable "words" {
 description = "A word pool to use for Mad Libs"
 type = object({
   nouns      = list(string),
   adjectives = list(string),
   verbs      = list(string),
   adverbs    = list(string),
   numbers    = list(number),
 })
}

variable "num_files" {
 default = 100
 type    = number
}


locals {
 uppercase_words = { for k, v in var.words : k => [for s in v : upper(s)] }
}

resource "random_shuffle" "random_nouns" {
 count = var.num_files
 input = local.uppercase_words["nouns"]
}

resource "random_shuffle" "random_adjectives" {
 count = var.num_files
 input = local.uppercase_words["adjectives"]
}

resource "random_shuffle" "random_verbs" {
 count = var.num_files
 input = local.uppercase_words["verbs"]
}

resource "random_shuffle" "random_adverbs" {
 count = var.num_files
 input = local.uppercase_words["adverbs"]
}

resource "random_shuffle" "random_numbers" {
 count = var.num_files
 input = local.uppercase_words["numbers"]
}

locals {
 templates = tolist(fileset(path.module, "templates/*.txt"))
}

resource "local_file" "mad_libs" {
 count    = var.num_files
 filename = "madlibs/madlibs-${count.index}.txt"
 content  = templatefile(element(local.templates, count.index),
   {
     nouns      = random_shuffle.random_nouns[count.index].result
     adjectives = random_shuffle.random_adjectives[count.index].result
     verbs      = random_shuffle.random_verbs[count.index].result
     adverbs    = random_shuffle.random_adverbs[count.index].result
     numbers    = random_shuffle.random_numbers[count.index].result
 })
}

data "archive_file" "mad_libs" {
 depends_on  = [local_file.mad_libs]
 type        = "zip"
 source_dir  = "${path.module}/madlibs"
 output_path = "${path.cwd}/madlibs.zip"
}
```


### 3.2.8 Applying changes

Tới đây chúng ta đã sẵn sàng để apply những kiến thức vừa rồi đã học. Chạy `terraform init` để Terrform download các provider và sau đó là `terraform apply`:

```
$ terraform init && terraform apply -auto-approve
...
local_file.mad_libs[71]: Creation complete after 0s [id=382048cc1c505b6f7c2ecd8d430fa2bcd787cec0]
local_file.mad_libs[54]: Creation complete after 0s 
[id=8b6d5cc53faf1d20f913ee715bf73dda8b635b5d]
data.archive_file.mad_libs: Reading...
data.archive_file.mad_libs: Read complete after 0s 
[id=4a151807e60200bff2c01fdcabeab072901d2b81]
 
Apply complete! Resources: 600 added, 0 changed, 0 destroyed.
```

Các tập tin trong thư mục hiện tại bây giờ như sau:

```
.
├── madlibs
│     ├── madlibs-0.txt
│   ├── madlibs-1.txt
 ...
│   ├── madlibs-98.txt
│   └── madlibs-99.txt
├──   madlibs.zip
├──    madlibs.tf
├──   templates
│   ├── alice.txt
│   ├── observatory.txt
│   └── photographer.txt
├── terraform.tfstate
├── terraform.tfstate.backup
└── terraform.tfvars
```

## 3.3 Tổng kết

Terraform cũng là một ngôn ngữ lập trình có khả năng tính toán. Trọng tâm của chương này là các hàm , các biểu thức và các template. 

{{<img src="/assets/images/posts/terraform/figure3.17.png" align="center" title="Expression reference" >}}

**Summary**

- Input variables tham số hóa cấu hình Terraform. Local variables lưu kết quả của một biểu thức. Output variables truyền dữ liệu đi khắp nơi, in ra cho người dùng đọc hoặc truyền vào các mô-đun khác.
- `for` expression cho phép bạn chuyển đổi một kiểu dữ liệu này thành một kiểu dữ liệu khác trong Terraform. Chúng có thể được kết hợp với các biểu thức khác để tạo ra các hàm bậc cao hơn.
- Các giá trị ngẫu nhiên phải được hạn chế. Tránh sử dụng các hàm cũ như `uuid()` và `timestamp()`, vì những hàm này sẽ gây ra các lỗi trong Terraform nếu không được kiểm soát chặt chẽ.
- Nén tệp bằng Archive provider. Bạn có thể cần chỉ định sự phụ thuộc bằng `depends_on`.
- hàm `templatefile()` trong Terraform cho phép bạn sử dụng cùng cú pháp với các biến interpolation để render nội dung của một tệp tin mẫu. Chỉ những biến được truyền vào hàm này mới có thể được sử dụng trong quá trình template hóa.
- `count` là một meta-argument trong Terraform cho phép bạn tạo ra nhiều instances của một resource một cách động. Để truy cập các instances được tạo ra bởi `count`, bạn có thể sử dụng cú pháp dạng mảng, ví dụ resource_name[index].