---
title: "Chapter 2 - Life cycle of a Terraform resource"
date: 2024-08-14T06:00:20+06:00
hero: /images/posts/terraform/chapter-2-hero.png
description: "Chapter 2 - Life cycle of a Terraform resource"
menu:
  sidebar:
    name: "Chapter 2 - Life cycle of a Terraform resource"
    identifier: chapter-2
    parent: terraform-in-action
    weight: 11
---

> Chương này bao gồm
> - Xây dựng và apply execution plan
> - Phân tích khi Terraform trigger function hook
> - Sử dụng Local provider để tạo và quản lý file
> - Mô phỏng, phát hiện và hiệu chỉnh configuration drift
> - Cơ bản về Terraform state management

Về cơ bản, Terraform là một công cụ quản lý trạng thái thực hiện các hoạt động CRUD (tạo, đọc, cập nhật, xóa) trên các managed resource. Thông thường, managed resource là cloud-based resource, tuy nhiên có một số các resource không phải là resource của cloud. Bất cứ thứ gì có thể được biểu diễn dưới dạng CRUD đều có thể được quản lý dưới dạng resource Terraform.

Trong chương này, chúng ta đi sâu vào Terraform bằng cách tìm hiểu vòng đời (life cycle) của một resource. Chúng ta có thể sử dụng bất kỳ resource nào cho tác vụ này, vì vậy hãy sử dụng resource không gọi bất kỳ API ra mạng bên ngoài. Những resource đặc biệt này được gọi là **local-only resource** và tồn tại trong giới hạn của Terraform hoặc máy tính đang chạy Terraform. Các local-only resource thường phục vụ các mục đích bên lề ví dụ như tạo private keys, self-signed TLS certificates, hoặc random ids.

## 2.1 Process overview

Chúng ta sẽ sử dụng resource là *local_file* từ Local provider để Terraform tạo, đọc, cập nhật và xóa tệp văn bản chứa một số đoạn đầu tiên trong Binh pháp Tôn Tử. Architecture diagram được thể hiện trong Hình 2.1.

**Hình 2.1** Inputs và outputs của kịch bản trên
{{<img src="/assets/images/posts/terraform/figure2.1.png" align="center" title="Inputs and outputs of the Sun Tzu scenario" >}}

{{< alert type="info" >}}
Mặc dù tệp văn bản thường không được coi là infrastructure nhưng bạn vẫn có thể deploy nó giống như cách bạn làm với EC2 Instance. Bạn có thể xem nó là một cơ sở hạ tầng để có thể thực hành và tìm hiểu về terraform.
{{< /alert >}}

Configuraton drift là có sự thay đổi trong cấu hình của một hệ thống mà không được ghi lại và đồng bộ hóa với mã nguồn IaC

Đầu tiên, chúng ta sẽ tạo resource. Tiếp theo, chúng ta sẽ mô phỏng configuraton drift và thực hiện cập nhật. Cuối cùng, chúng ta sẽ dọn dẹp bằng `terraform destroy`. Quy trình được thể hiện trong Hình 2.2.

**Hình 2.2** (1) Chúng ta tạo resource, sau đó (2) đọc và (3) update nó, cuối cùng là (4) xoá nó
{{<img src="/assets/images/posts/terraform/figure2.2.png" align="center" title="We create the resource, then read and update it, and finally delete it" >}}

### 2.2.1 Life cycle function hooks

Trong Terraform, mỗi resource được định nghĩa đều implememt một interface là *resource schema interface*. Điều này có nghĩa là mỗi resource đều định nghĩa các CURD function hook trong đó có `Create()`, `Read()`, `Update()` và `Delete()`. Terraform sẽ gọi những hook này khi gặp các điều kiện nhất định. 

- **Create()** Function hook này được Terraform gọi khi tạo một resource mới, nhiệm vụ của Create() là tạo ra các resource trên các deployment target như AWS, GCP, Azure,...
- **Read()** Function hook này được Terraform gọi khi thực hiện việc lập kế hoạch (plan) cho các thay đổi. Nhiệm vụ của hàm này là đọc các thuộc tính hiện tại của resource và đưa vào state file.
- **Update()** Function hook này được Terraform gọi khi cần cập nhật một resource hiện có. Nhiệm vụ của hàm này là thực hiện các thay đổi cần thiết trong Deployment Target.
- **Delete()**: Function hook này được Terraform gọi khi cần xóa một resource. Nhiệm vụ của hàm này là xóa resource khỏi Deployment target.

Việc định nghĩa các hàm này trong mỗi resource giúp Terraform có thể quản lý vòng đời của các resource một cách hiệu quả. Terraform sẽ tự động gọi các hàm này khi cần thực hiện các thao tác tương ứng, đảm bảo sự nhất quán giữa mã nguồn IaC và trạng thái thực tế của hệ thống.

Vì là resource nên *local_file* cũng implement resource schema interface. Điều đó có nghĩa là nó define các function hook cho `Create()`, `Read()`, `Update()` và `Delete()`. Điều này trái ngược với local_file data source, vốn chỉ thực hiện Read() (Hình 2.3). Trong kịch bản này, chúng ta sẽ tìm hiểu khi nào và tại sao mỗi function hook này được gọi.

**Hình 2.3** Hai tài nguyên trong Local provider, 1 là managed resource, 2 là unmanaged data source. Managed resource thì implement full CRUD, trong khi data resource chỉ implement Read()
{{<img src="/assets/images/posts/terraform/figure2.3.png" align="center" title="Hai tài nguyên trong Local provider, 1 là managed resource, 2 là unmanaged data source. Managed resource thì implement full CRUD, trong khi data resource chỉ implement Read()" >}}

## 2.2 Khai báo local file resource

Bắt đầu bằng việc tạo workspace mới cho Terraform. Thực hiện điều này bằng cách tạo một thư mục rỗng mới trên máy tính của bạn. Hãy chắc chắn rằng trong folder này không chứa bất kì một configuration code nào nữa, bởi vì Terraforn sẽ ghép tất cả các .tf file lại với nhau. Trong không gian làm việc này, tạo 1 file mới tên là main.tf và thêm đoạn code sau:

**Listirng 2.1** main.tf
```
terraform {
  required_version = ">= 0.15"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
 
resource "local_file" "literature" {
    filename = "art_of_war.txt"
    content = <<-EOT
      Sun Tzu said: The art of war is of vital importance to the State.
 
      It is a matter of life and death, a road either to safety or to 
      ruin. Hence it is a subject of inquiry which can on no account be
      neglected.
    EOT
}
```

{{< alert type="success" >}}
Chuỗi <<- được gọi là chuỗi heredoc. Đây là một cách đặc biệt để định nghĩa một chuỗi ký tự.  Nó cho phép bạn tạo ra các chuỗi ký tự nhiều dòng một cách dễ dàng và dễ đọc hơn so với cách truyền thống.
{{< /alert >}}

Có hai configuration block trong Listing 2.1 ở trên. Block đầu tiên, `terraform {...}`, là block đặt biệt, chịu trách nhiệm cấu hình Terraform. Công dụng chính của nó là:
- **Version-locking**:  Bạn có thể chỉ định phiên bản Terraform đang sử dụng, đảm bảo rằng mã của bạn sẽ hoạt động một cách nhất quán ngay cả khi có các bản cập nhật Terraform trong tương lai.
- **Cấu hình nơi lưu trữ state file**: erraform sử dụng một state file để theo dõi trạng thái của cơ sở hạ tầng của bạn. Bạn có thể chỉ định nơi lưu trữ state file, ví dụ như một backend S3 bucket trên AWS. (Chúng ta sẽ thảo luận thêm ở [Chapter 6]())
- **Cấu hình nơi tải xuống providers**: Terraform sử dụng các providers để tương tác với các nền tảng cung cấp dịch vụ như AWS, Azure, GCP, v.v. Bạn có thể chỉ định nơi Terraform tải xuống các provider này.

Hiện tại, Local provider vẫn chưa được cài đặt, chính vì vậy chúng ta cần phải run `terraform init` command trước.

Block thứ hai đó là một resource block đang mô tả một `local_file` resource. Nó cung cấp một tệp văn bản với tên tệp và nội dung. Trong trường hợp này, nội dung sẽ chứa một vài đoạn đầu đầu tiên trong Binh pháp Tôn Tử, và tên tệp sẽ là art_of_war.txt. Chúng ta sẽ sử dụng cú pháp heredoc (<<-) để nhập một chuỗi ký tự nhiều dòng.

## 2.3 Khởi tạo workspace

Nếu chưa được khởi tạo, Terraform không biết về không gian làm việc của bạn, chứ đừng nói đến việc nó có nhiệm vụ tạo hoặc quản lý bất cứ thứ gì. Cấu hình Terraform phải luôn được initialized ít nhất một lần, nhưng bạn có thể phải khởi tạo lại nếu thêm các provider hoặc các module mới. Bạn không cần lo lắng về việc quên chạy `terraform init` vì Terraform sẽ luôn nhắc về điều này khi cần. Hơn nữa, `terrarofm init` là một *idempotent* command, có nghĩa là bạn có thể gọi nó bao nhiêu lần tùy thích mà không sợ bị ảnh hưởng gì đến cấu hình cua mình.

Chạy `terraform init` ngay bây giờ, chúng ta sẽ nhận được output tương tự như sau:
```
$ terraform init
 
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/local versions matching "~> 2.0"...
- Installing hashicorp/local v2.0.0...
- Installed hashicorp/local v2.0.0 (signed by HashiCorp)
 
Terraform has created a lock file .terraform.lock.hcl to record the
provider selections it made above. Include this file in your version 
control repository so that Terraform can guarantee to make the same 
selections by default when you run "terraform init" in the future.
 
Terraform has been successfully initialized!
 
You may now begin working with Terraform. Try running "terraform plan" to 
see any changes that are required for your infrastructure. All Terraform 
commands should now work.
 
If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, 
other commands will detect it and remind you to do so if necessary.
```

Sau khi khởi tạo, Terraform tạo ra một thư mục ẩn là `.terraform` để cài đặt các plugin và các module. Cấu trúc thư mục này cho Terraform workspace hiện tại như sau:
```
.
├── .terraform
│    └── providers
│        └── registry.terraform.io
│            └── hashicorp
│                └── local
│                    └── 2.0.0
│                        └── darwin_amd64
│                            └── terraform-provider-local_v2.0.0_x5
├── .terraform.lock.hcl
└── main.tf
 
7 directories, 3 files
```

Bởi vì chúng ta đã khai báo resource `local_file` trong main.tf, Terraform đủ thông minh để nhận ra rằng nó là resource của provider Local. Vì vậy, Terraform tra cứu tài nguyên và tải xuống từ provider registry. Bạn không phải khai báo một provider block rỗng (dạng như `provider "local" {}`) trừ khi bạn muốn.

{{< alert type="success" >}}
Thực hiện version-locking các provider mà bạn sử dụng. Điều nãy sẽ có hai lợi ích sau:
1. **Tính lặp lại của triển khai**: Khi bạn version lock các provider, bạn đảm bảo rằng bất kể khi nào bạn chạy lại cấu hình Terraform, nó sẽ sử dụng chính xác cùng một phiên bản của các provider. Điều này giúp đảm bảo rằng triển khai của bạn sẽ nhất quán và lặp lại được, ngay cả khi có các bản cập nhật provider trong tương lai.
2. **Tránh những thay đổi bất ngờ**: Các bản cập nhật provider có thể đưa ra những thay đổi về hành vi, API hoặc tài nguyên được hỗ trợ. Version locking giúp bạn tránh những thay đổi bất ngờ như vậy, đảm bảo rằng cấu hình Terraform của bạn sẽ hoạt động như mong đợi.
{{< /alert >}}

Để version lock các provider, bạn có thể chỉ định chính xác phiên bản provider mà bạn muốn sử dụng trong cấu hình Terraform, ví dụ:
```
provider "aws" {
  version = "~> 3.0"
}
```

Hoặc bạn cũng có thể sử dụng `terraform` block để chỉ định phiên bản Terraform và các provider:
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.14"
}
```


## 2.4 Tạo execution plan

Trước khi tạo resource `local_file` bằng `terraform apply`, chúng ta có thể xem trước những gì Terraform dự định thực hiện bằng cách chạy `terraform plan`. Bạn nên chạy `terraform plan` mỗi trước khi triển khai, vì mục đích làm cho series ngắn gọn,nội dung trong series thường bỏ qua bước này, nhưng bạn vẫn nên thực hiện, ngay cả khi không được đề cập. `terraform plan` thông báo cho bạn về những gì Terraform dự định làm và hoạt động như một linter, cho bạn biết về bất kỳ lỗi nào kể cả là lỗi cú pháp. Đây là một lệnh read-only, không làm thay đổi trạng thái của infrastructure đã triển khai và giống như `terraform init`, nó cũng là idempotent command nên có thể chạy mà không sợ bị ảnh hưởng gì.

Tạo một execution plan bằng cách run `terraform plan`:
```
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
 
__________________________________________________________________________
 
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 
Terraform will perform the following actions:
 
  # local_file.literature will be created
  + resource "local_file" "literature" {
      + content              = <<~EOT
            Sun Tzu said: The art of war is of vital importance to the State.
 
            It is a matter of life and death, a road either to safety or to
            ruin. Hence it is a subject of inquiry which can on no account be
            neglected.
        EOT
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "art_of_war.txt"
      + id                   = (known after apply)
}
 
Plan: 1 to add, 0 to change, 0 to destroy.
__________________________________________________________________________
 
Note: You didn't specify an "-out" parameter to save this plan, so 
Terraform can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

{{< alert type="warning" >}}
Khi nào một plan có thể bị thất bại? 

Terraform plan có thể thất bại vì nhiều lý do, chẳng hạn như mã cấu hình của bạn không hợp lệ nếu có vấn đề về phiên bản hoặc các vấn đề liên quan đến mạng. Hoặc đôi khi hiếm khi xảy ra, một plan bị lỗi do lỗi trong mã nguồn của provider. Bạn cần đọc kỹ bất kỳ thông báo lỗi để kiểm tra. Để có nhiều logs chi tiết hơn, bạn có thể bật tính năng log ở mức trace bằng cách đặt biến môi trường TF_LOG=trace, command: `export TF_LOG=trace`.
{{< /alert >}}

Như bạn có thể thấy từ output, Terraform đang cho chúng ta biết rằng nó muốn tạo một resource là `local_file`. Bên cạnh các attribute mà chúng ta cung cấp, nó cũng muốn đặt một computed attribute có tên là `id`, đây là một meta-attribute mà Terraform đặt trên tất cả các tài nguyên. Nó được sử dụng để xác định duy nhất tài nguyên trong cấu hình thực tế và các tính toán nội bộ.

Một số plan sẽ tốn nhiều thời gian để hoàn thành, tất cả đều liên quan đến số lượng resource bạn đang triển khai và số lượng resource bạn đã có trong state file của mình.

{{< alert type="info" >}}
Nếu `terraform plan` bị chậm, hãy tắt chế độ logs trace và cân nhắc về việc tăng parallelism (-parallelism=n). Terraform sẽ tạo ra các "worker" để thực hiện các tác vụ song song, qua đó giúp giảm thời gian thực hiện plan. Mặc định, Terraform sẽ có parallelism là 10.
{{< /alert >}}

Mặc dù output của `terraform plan` khá đơn giản nhưng có rất nhiều điều đang diễn ra mà bạn cần lưu ý. Ba giai đoạn chính của `terraform plan` như sau:
1. **Đọc configuration file và state file**: Terrform đọc configuration file và state file(nếu state file tồn tại)
2. **Xác định các hành động cần thực hiện**: Terraform thực hiện các tính toán để xác định những gì cần phải làm để đạt được trạng thái mong muốn. Có thể là `Create()`, `Read()`, `Update()`, `Delete()` hoặc No-op (không làm gì)
3. **Output plan**: Execution plan đảm bảo rằng hành động diễn ra theo đúng thứ tự để tránh các lỗi phát sinh. Điều này rất phù hợp khi chúng ta có nhiều tài nguyên để quản lý.

Hình 2.4 mô tả chi tiết về những gì diễn ra khi dùng `terraform plan`.

**Hình 2.4** Các bước Terraform thực hiện tạo 1 execution plan để triển khai infrastructure mới
{{<img src="/assets/images/posts/terraform/figure2.4.png" align="center" title="Các bước Terraform thực hiện tạo 1 execution plan để triển khai infrastructure mới" >}}

Chúng ta chưa đề cập đến dependency graph (biểu đồ phụ thuộc), một phần quan trọng của Terraform. Khi chạy Terraform Plan, Terraform sẽ tạo ra một đồ thị phụ thuộc, thể hiện các mối quan hệ "explicit" (rõ ràng) và "implicit" (ngầm định) giữa các tài nguyên và provider.

**Explicit dependencies** là những mối quan hệ được định nghĩa **rõ ràng** trong cấu hình Terraform, ví dụ như khi một tài nguyên A cần phải được tạo trước một tài nguyên B. 

**Implicit dependencies** là những mối quan hệ ngầm định, phát sinh từ cách thức các tài nguyên liên kết với nhau. 

Terraform có một command đặt biệt để hiển thị dependency graph: `terrform graph`. Command này tạo ra một dot file có thể chuyển thành dạng đồ thị bằng nhiều công cụ khác nhau. Hình 2.5 thể hiện đồ thị DOT được tạo ra.

**Hình 2.5** Dependency graph
{{<img src="/assets/images/posts/terraform/figure2.5.png" align="center" title="Dependency graph" >}}

Dependency graph này có một số node, bao gồm một hode dành cho Local provider, một node dành cho `local_file` resource và một số meta node khác tương ứng với các hành động quản lý. Trong quá trình `apply`, Terraform sẽ duyệt qua dependency graph để đảm bảo rằng mọi thứ được thực hiện theo đúng thứ tự.

### 2.4.1 Inspecting the plan

Chúng ta có thể đọc output của `terraform plan` dưới dạng JSON, điều này có thể giúp chúng ta tương tác với các custom tools hoặc thực thi các policy as code ([Chapter 13]()).

Đầu tiên, lưu output của excution plan bằng option *-out*: 
```
$ terraform plan -out plan.out
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.
 
__________________________________________________________________________
 
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 
Terraform will perform the following actions:
 
  # local_file.literature will be created
  + resource "local_file" "literature" {
      + content              = <<~EOT
            Sun Tzu said: The art of war is of vital importance to the State.
 
            It is a matter of life and death, a road either to safety or to
            ruin. Hence it is a subject of inquiry which can on no account be
            neglected.
        EOT
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "art_of_war.txt"
      + id                   = (known after apply)
}
 
Plan: 1 to add, 0 to change, 0 to destroy.
__________________________________________________________________________
 
This plan was saved to: plan.out
 
To perform exactly these actions, run the following command to apply:
terraform apply "plan.out"
```

*plan.out* được lưu dưới dạng binary file, bước tiếp theo là convert nó thành dạng JSON. Điều này có thể được thực hiện bằng dùng pipe để đưa output `terraform show` vào 1 output file. Chi tiết về pipe bạn có thể xem tại [đây](/posts/lpic-1-study-guide/exploring-linux-command-line-tools/using-streams-redirection-and-pipes/).
```
$ terraform show -json plan.out > plan.json
```

Cuối cùng, chúng ta cũng có một tệp JSON để có thể xem được rồi.
```
$ cat plan.json
{"format_version":"0.1","terraform_version":"0.15.0","planned_values":{"roo
t_module":{"resources":[{"address":"local_file.literature","mode":"managed"
,"type":"local_file","name":"literature","provider_name":"registry.terrafor
m.io/hashicorp/local","schema_version":0,"values":{"content":"Sun Tzu said: 
The art of war is of vital importance to the State.\n\nIt is a matter of 
life and death, a road either to safety or to \nruin. Hence it is a subject 
of inquiry which can on no account 
be\nneglected.\n","content_base64":null,"directory_permission":"0777","file
_permission":"0777","filename":"art_of_war.txt","sensitive_content":null}}]
}},"resource_changes":[{"address":"local_file.literature","mode":"managed",
"type":"local_file","name":"literature","provider_name":"registry.terraform
.io/hashicorp/local","change":{"actions":["create"],"before":null,"after":{
"content":"Sun Tzu said: The art of war is of vital importance to the 
State.\n\nIt is a matter of life and death, a road either to safety or to 
\nruin. Hence it is a subject of inquiry which can on no account 
be\nneglected.\n","content_base64":null,"directory_permission":"0777","file
_permission":"0777","filename":"art_of_war.txt","sensitive_content":null},"
after_unknown":{"id":true}}}],"configuration":{"root_module":{"resources":[
{"address":"local_file.literature","mode":"managed","type":"local_file","na
me":"literature","provider_config_key":"local","expressions":{"content":{"c
onstant_value":"Sun Tzu said: The art of war is of vital importance to the 
State.\n\nIt is a matter of life and death, a road either to safety or to 
\nruin. Hence it is a subject of inquiry which can on no account 
be\nneglected.\n"},"filename":{"constant_value":"art_of_war.txt"}},"schema_
version":0}]}}}
```

## 2.5 Tạo một *local_file* resource

Bây giờ, hãy run `terraform apply` để triển khai execution plan trên.
```
$ terraform apply
$ terraform apply
 
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create
 
Terraform will perform the following actions:
 
  # local_file.literature will be created
  + resource "local_file" "literature" {
      + content              = <<-EOT
            Sun Tzu said: The art of war is of vital importance to the State.
 
            It is a matter of life and death, a road either to safety or to
            ruin. Hence it is a subject of inquiry which can on no account be
            neglected.
        EOT
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "art_of_war.txt"
      + id                   = (known after apply)
}
 
Plan: 1 to add, 0 to change, 0 to destroy.
 
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.
 
  Enter a value:
```

`terraform apply` cũng sẽ tạo ra một plan giống hệt như `terraform plan`. Trên thực tế chúng ta còn có thể apply một execution plan của một `terraform plan` một cách trực tiếp như sau:

```
$ terraform plan -out plan.out && terraform apply "plan.out"
```

{{< alert type="info" >}}
Việc chia plan và apply riêng biệt giúp chúng ta có thể chạy các vụ Terraform một cách tự động, sẽ đề cập ở [Chapter 12]()
{{< /alert >}}

Bất kể bạn tạo execution plan theo cách nào, bạn cũng nên xem lại nội dung của plan trước khi áp dụng. Trong quá trình `apply`, Terraform tạo và xoá cơ sở hạ tầng, điều này tất nhiên gây ra hậu quả. Nếu bạn không cẩn thận, một lỗi hoặc lỗi đánh máy đơn giản có thể xóa sạch toàn bộ cơ sở hạ tầng của bạn trước khi bạn kịp phản ứng với nó. Đối với bài này, chúng ta không cần phải lo lắng nhiều vì đang không tương tác với cơ sở hạ tầng thực mà chỉ đang làm với một local_file.

Quay trở lại command line, nhập `yes` để xác nhận và triển khai. Output như sau:
```
$ terraform apply
...
  Enter a value: yes
 
local_file.literature: Creating...
local_file.literature: Creation complete after 0s [id=df1bf9d6-c6cf-f9cb-
34b7-dc0ba10d5a1d]
 
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Hai file được tạo ra cần lưu ý ở đây là: *art_of_war.txt* vaf *terraform.tfstate* . Cấu trúc thư mục của bạn sẽ như sau (trừ những hidden file):
```
.
├── art_of_war.txt
├── main.tf
└── terraform.tfstate
```

File *terraform.tfstate* mà bạn đang nhìn thấy là file trạng thái của Terraform dùng để theo dõi các resource mà nó quản lý. Nó được sử dụng để thực hiện các thay đổi của chúng ta trong plan và phát hiện sai lệch cấu hình (gọi chung là configuration driff). State file hiện tại sẽ có nội dung như sau:
```
{
  "version": 4,
  "terraform_version": "1.8.0",
  "serial": 5,
  "lineage": "4664dd7b-3400-f7f6-b9be-5f406a43c202",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "local_file",
      "name": "literature",
      "provider": "provider[\"registry.terraform.io/hashicorp/local\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "content": "Sun Tzu said: The art of war is of vital importance to the State.\n \nIt is a matter of life and death, a road either to safety or to \nruin. Hence it is a subject of inquiry which can on no account be\nneglected.\n",
            "content_base64": null,
            "content_base64sha256": "hDuNOQFa7+zt5N+RHBS5csLiVWaMUQE6UOYr957qGMA=",
            "content_base64sha512": "RsGUguODUfRibXhTLTyf2TiE0B9T6752RH8VAnPx8x2aTlXhfSScsOc2i9D53mTYGf+hzl5uO/fDBl599ofViw==",
            "content_md5": "fe7c50efe880991319d04f41f9b6a4ca",
            "content_sha1": "12763987bd4c7d5d9b69d0eca3d2e78c92663d1c",
            "content_sha256": "843b8d39015aefecede4df911c14b972c2e255668c51013a50e62bf79eea18c0",
            "content_sha512": "46c19482e38351f4626d78532d3c9fd93884d01f53ebbe76447f150273f1f31d9a4e55e17d249cb0e7368bd0f9de64d819ffa1ce5e6e3bf7c3065e7df687d58b",
            "directory_permission": "0777",
            "file_permission": "0777",
            "filename": "art_of_war.txt",
            "id": "12763987bd4c7d5d9b69d0eca3d2e78c92663d1c",
            "sensitive_content": null,
            "source": null
          },
          "sensitive_attributes": [
            [
              {
                "type": "get_attr",
                "value": "sensitive_content"
              }
            ]
          ]
        }
      ]
    }
  ],
  "check_results": null
}
```

{{< alert type="warning" >}}
Điều quan trọng là không chỉnh sửa, xóa hoặc giả mạo tệp terraform.tfstate, nếu không Terraform có thể mất dấu vết các tài nguyên mà nó quản lý. Có thể khôi phục lại state file bị hỏng hoặc bị thiếu, tuy nhiên việc thực hiện rất khó khăn và tốn thời gian.
{{< /alert >}}

Chúng ta sẽ kiểm tra xem file *art_of_war.txt* có đúng như mong đợi của mình không bằng việc `cat` file đó ra như sau:
```
$ cat art_of_war.txt
Sun Tzu said: The art of war is of vital importance to the State.
 
It is a matter of life and death, a road either to safety or to 
ruin. Hence it is a subject of inquiry which can on no account be
neglected.
```

Câu hỏi được đặt ra là Terraform đã tạo file đó như thế nào?

Trong quá trình `apply`, Terraform đã gọi hook `Create()` trên `local_file` (Hình 2.6).
**Hình 2.6** Local provider - resource local_file
{{<img src="/assets/images/posts/terraform/figure2.6.png" align="left" title="Local provider - resource local_file" >}}

Để giúp bạn biết Create() làm gì, listing sau đây hiển thị mã nguồn từ provider. 

{{< alert type="info" >}}
Hãy thư giãn và đừng lo lắng về việc hiểu code. Chúng ta sẽ xem xét hoạt động bên trong của các provider trong [Chapter 11]() sau.
{{< /alert >}}


**Listing 2.3** Local file create
```
func resourceLocalFileCreate(d *schema.ResourceData, _ interface{}) error {
  content, err := resourceLocalFileContent(d)
  if err != nil {
    return err
  }
 
  destination := d.Get("filename").(string)
 
  destinationDir := path.Dir(destination)
  if _, err := os.Stat(destinationDir); err != nil {
    dirPerm := d.Get("directory_permission").(string)
    dirMode, _ := strconv.ParseInt(dirPerm, 8, 64)
    if err := os.MkdirAll(destinationDir, os.FileMode(dirMode)); err != nil {
      return err
    }
  }
 
  filePerm := d.Get("file_permission").(string)
 
  fileMode, _ := strconv.ParseInt(filePerm, 8, 64)
 
  if err := ioutil.WriteFile(destination, []byte(content), os.FileMode(fileMode)); 
     ➥ err != nil {
    return err
  }
 
  checksum := sha1.Sum([]byte(content))
  d.SetId(hex.EncodeToString(checksum[:]))
 
  return nil
}
```

## 2.6 Performing No-OP

Terraform có thể đọc các resource hiện có để đảm bảo rằng chúng ở trạng thái cấu hình mong muốn. Một cách để làm điều này là chạy `terraform plan`. Khi `terraform plan` được chạy, Terraform gọi Read() trên mỗi resource trong state file. Vì hiện tại, state fiel của chúng ta chỉ có một tài nguyên, nên Terraform chỉ gọi Read() trên *local_file*. Hình 2.7 mô tả điều này:

**Hình 2.7** Terraform plan gọi `Read()` hook trên *local_file* resource
{{<img src="/assets/images/posts/terraform/figure2.7.png" align="left" title="Local provider - resource local_file" >}}

Bây giờ chúng ta hãy thử chạy `terraform plan` để xem No-Op là như thế nào:
```
$ terraform plan
local_file.literature: Refreshing state... 
[id=12763987bd4c7d5d9b69d0eca3d2e78c92663d1c]
 
No changes. Infrastructure is up-to-date.
 
That Terraform did not detect any differences between your configuration 
and the remote system(s). As a result, there are no actions to take.
```

Không có gì thay đổi như những gì chúng ta đang mong đợi. Khi một hook function Read() trả về `no changes`, hành động thực hiện sau đó gọi là no-operation (no-op) tức là gần như không làm gì. Chúng ta hãy xem hình 2.8

**Hình 2.8** Các bước Terraform thực hiện khi tạo một execution plan khi đã triển khai tài nguyên
{{<img src="/assets/images/posts/terraform/figure2.8.png" align="left" title="Các bước Terraform thực hiện khi tạo một execution plan khi đã triển khai tài nguyên" >}}

Cuối cùng, đây là code của provider, thực hiện Read() function. Một lần nữa cũng chỉ cần xem qua chứ đừng quá lo lắng về việc hiểu các đoạn code này. Chưa thực sự cần thiết với mình hiện tại.

**Listing 2.4** Local file **read**
```
func resourceLocalFileRead(d *schema.ResourceData, _ interface{}) error {
   // If the output file doesn't exist, mark the resource for creation.
   outputPath := d.Get("filename").(string)
   if _, err := os.Stat(outputPath); os.IsNotExist(err) {
       d.SetId("")
       return nil
   }

   // Verify that the content of the destination file matches the content we
   // expect. Otherwise, the file might have been modified externally and we
   // must reconcile.
   outputContent, err := ioutil.ReadFile(outputPath)
   if err != nil {
       return err
   }

   outputChecksum := sha1.Sum([]byte(outputContent))
   if hex.EncodeToString(outputChecksum[:]) != d.Id() {
       d.SetId("")
       return nil
   }

   return nil
}
```

## 2.7 Cập nhật local_file resource

Chúng ta sẽ cập nhật nội dung của file *art_of_war.txt* (thêm một đoạn văn bản nữa). Cập nhật và tích hợp vào Terraform và điều quan trọng là chúng ta phải hiểu cách hoạt động của update. 

Bây giờ bạn hãy sửa mã của bạn trong main.tf như sau:

**Listing 2.5** main.tf
```
terraform {
  required_version = ">= 0.15"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
 
resource "local_file" "literature" {
    filename = "art_of_war.txt"
    content = <<-EOT
      Sun Tzu said: The art of war is of vital importance to the State.
 
      It is a matter of life and death, a road either to safety or to 
      ruin. Hence it is a subject of inquiry which can on no account be
      neglected.

      The art of war, then, is governed by five constant factors, to be
      taken into account in one's deliberations, when seeking to
      determine the conditions obtaining in the field.

      These are: (1) The Moral Law; (2) Heaven; (3) Earth; (4) The
      Commander; (5) Method and discipline.
    EOT
}
```

Chúng ta không cần phải họclệnh đặc biệt nào để thực hiện việc update; tất cả những gì chúng ta cần đó là `terraform apply`. Tuy nhiên, trước khi làm điều đó, hãy chạy `terraform plan` để xem kế hoạch thực hiện được tạo ra trông như thế nào:
```
$ terraform plan
local_file.literature: Refreshing state...  [id=12763987bd4c7d5d9b69d0eca3d2e78c92663d1c]
 
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement
 
Terraform will perform the following actions:
 
  # local_file.literature must be replaced
-/+ resource "local_file" "literature" {
      ~ content              = <<-EOT # forces replacement
            Sun Tzu said: The art of war is of vital importance to the State.
 
            It is a matter of life and death, a road either to safety or to
            ruin. Hence it is a subject of inquiry which can on no account be
            neglected.
          +
          + The art of war, then, is governed by five constant factors, to be
          + taken into account in one's deliberations, when seeking to
          + determine the conditions obtaining in the field.
          +
          + These are: (1) The Moral Law; (2) Heaven; (3) Earth; (4) The
          + Commander; (5) Method and discipline.
        EOT
      ~ id                   = "907b35148fa2bce6c92cba32410c25b06d24e9af" 
-> (known after apply)
        # (3 unchanged attributes hidden)
    }
 
Plan: 1 to add, 0 to change, 1 to destroy.
 
____________________________________________________________________________
 
Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```

Terraform nhận ra chúng ta đã thay đổi thuộc tính `content` và do đó đề xuất xoá tài nguyên cũ và tạo tài nguyên mới thay thế. Việc xoá và tạo lại được thực hiện thay vì cập nhật thuộc tính `content` vì `content` được đánh dấu là `force new attribute`, có nghĩa là nếu bạn thay đổi thuộc tính đó, toàn bộ tài nguyên sẽ được xem là tainted - ô nhiễm (hoặc nhiễm độc). Trong Terraform, thuật ngữ "tainted" (bị ô nhiễm) được sử dụng để mô tả một tài nguyên (resource) đã được đánh dấu để tạo lại (recreate) trong lần "apply" tiếp theo. Để đạt được trạng thái mong muốn mới, Terraform phải tạo lại tài nguyên từ đầu. Đây là một ví dụ kinh điển về cơ sở hạ tầng bất biến (immutable infrastructure), mặc dù không phải tất cả các attribute của tài nguyên Terraform được quản lý đều hoạt động như thế này. Trên thực tế, hầu hết các tài nguyên đều có cập nhật attribute mà không bị tainted. Sự khác biệt giữa mutable và immutable update được thể hiện trong Hình 2.9

**Hình 2.9** Khác biệt giữa immutable update và mutable update
{{<img src="/assets/images/posts/terraform/figure2.9.png" align="left" title="Khác biệt giữa immutable update và mutable update" >}}


{{< alert type="warning" >}}
"Force new" nghe có vẻ đáng sợ. Mặc dù việc delete và re-create các infrastructure tainted nghe có vẻ đáng lo ngại, nhưng `terraform plan` sẽ luôn cho bạn biết trước những gì Terraform sẽ làm. Hơn nữa, Terraform là một tool phù hợp trong việc tạo ra các môi trường có khả năng lặp lại (repeatable), vì vậy việc re-create một phần cơ sở hạ tầng không phải là vấn đề đáng lo lắng. Vấn đề tiềm ẩn duy nhất là dịch vụ của chúng ta có bị ngừng hoạt động hay không. Nếu bạn hoàn toàn không thể chấp nhận bất kỳ thời gian ngừng hoạt động vào, thì hãy tiếp tục theo dõi [Chương 9]() khi chúng ta đề cập đến cách thực hiện việc triển khai zero-downtime với Terraform.
{{< /alert >}}

Flow chart của việc tạo ra execution plan cho việc update được thể hiện ở hình 2.10

**Hình 2.10** Các bước Terraform thực hiện tạo ra execution plan khi thực hiện update
{{<img src="/assets/images/posts/terraform/figure2.10.png" align="left" title="Các bước Terraform thực hiện tạo ra execution plan khi thực hiện update" >}}

Hãy tiếp tục và áp dụng các thay đổi được đề xuất từ execution plan bằng cách chạy lệnh `terraform apply -auto-approve`. Cờ `-auto-appove` yêu cầu Terraform bỏ qua bước approve thủ công và áp dụng ngay các thay đổi.

```
$ terraform apply -auto-approve
local_file.literature: Refreshing state... [id=907b35148fa2bce6c92cba32410c25b06d24e9af]
local_file.literature: Destroying... [id=907b35148fa2bce6c92cba32410c25b06d24e9af]
local_file.literature: Destruction complete after 0s
local_file.literature: Creating...
local_file.literature: Creation complete after 0s [id=657f681ea1991bc54967362324b5cc9e07c06ba5]
 
Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```

{{< alert type="warning" >}}
*-auto-approve* khá nguy hiểm nếu bạn không review kĩ lưỡng kết quả execution plan. Hãy chắc rằng bạn đã review cẩn thận các nội dung trước khi sử dụng tuỳ chọn này.
{{< /alert >}}

Bạn có thể kiểm tra nội dung của file đã được update chưa bằng các cat nó ra một lần nữa.
```
$ cat art_of_war.txt
Sun Tzu said: The art of war is of vital importance to the State.
 
It is a matter of life and death, a road either to safety or to
ruin. Hence it is a subject of inquiry which can on no account be
neglected.
 
The art of war, then, is governed by five constant factors, to be
taken into account in one's deliberations, when seeking to
determine the conditions obtaining in the field.
 
These are: (1) The Moral Law; (2) Heaven; (3) Earth; (4) The
Commander; (5) Method and discipline.
```

### 2.7.1 Phát hiện configuration drift

Khi đọc đến đây, chúng ta đã có thể tạo và cập nhật tài nguyên là một tệp văn bản. Nhưng điều gì sẽ xảy ra nếu có những thay đổi đặc biệt đối với tệp thông qua các phương tiện bên ngoài Terraform? **Configuration drift** là hiện tượng thường xảy ra trong trường hợp có nhiều người dùng có đặc quyền trên cùng một hệ thống. Nếu bạn có tài nguyên trên cloud, điều này tương đương với việc ai đó thực hiện các thay đổi bằng cách vào màn hình console rồi nhấp chuột để chỉnh sửa đối với cơ sở hạ tầng đã triển khai. Terraform xử lý vấn đề Configuration drift như thế nào? Nó xử lý bằng cách tính toán sự khác biệt giữa trạng thái hiện tại (current state) và trạng thái mong muốn (desired state) và thực hiện cập nhật.

Chúng ta có thể mô phỏng **configuration drift** bằng cách sửa đổi trực tiếp *art_of_war.txt*. Trong tệp này, thay thế từ "Sun Tzu" bằng "Napoleon". Nội dung của tệp art_of_war.txt của chúng ta bây giờ sẽ là:
```
Napoleon said: The art of war is of vital importance to the
State.

It is a matter of life and death, a road either to safety or to
ruin. Hence it is a subject of inquiry which can on no account be
neglected.

The art of war, then, is governed by five constant factors, to be
taken into account in one's deliberations, when seeking to
determine the conditions obtaining in the field.

These are: (1) The Moral Law; (2) Heaven; (3) Earth; (4) The
Commander; (5) Method and discipline.
```

Trích dẫn sai này rõ ràng là không đúng sự thật, vì vậy chúng ta muốn Terraform phát hiện ra rằng **configuration drift** đã xảy ra và khắc phục nó. Chạy `terraform plan` để xem output:

```
$ terraform plan
local_file.literature: Refreshing state... [id=657f681ea1991bc54967362324b5cc9e07c06ba5]
 
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create
 
Terraform will perform the following actions:
 
  # local_file.literature will be created
  + resource "local_file" "literature" {
      + content              = <<-EOT
            Sun Tzu said: The art of war is of vital importance to the State.
 
            It is a matter of life and death, a road either to safety or to
            ruin. Hence it is a subject of inquiry which can on no account be
            neglected.
 
            The art of war, then, is governed by five constant factors, to be
            taken into account in one's deliberations, when seeking to
            determine the conditions obtaining in the field.
 
            These are: (1) The Moral Law; (2) Heaven; (3) Earth; (4) The
            Commander; (5) Method and discipline.
        EOT
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "art_of_war.txt"
      + id                   = (known after apply)
    }
 
Plan: 1 to add, 0 to change, 0 to destroy.
 
____________________________________________________________________________
 
Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```

Đợi đã, chuyện gì vừa xảy ra? Terraform dường như đã quên rằng có một resource mà nó quản lý thậm chí còn tồn tại và do đó đang đề xuất tạo một resource mới. Trên thực tế, Terraform không quên rằng resource mà nó quản lý đang tồn tại - resource vẫn tồn tại trong tệp trạng thái và bạn có thể xác minh bằng cách chạy `terraform show`:

```
$ terraform show
# local_file.literature:
resource "local_file" "literature" {
    content              = <<-EOT
        Sun Tzu said: The art of war is of vital importance to the State.
 
        It is a matter of life and death, a road either to safety or to
        ruin. Hence it is a subject of inquiry which can on no account be
        neglected.
        The art of war, then, is governed by five constant factors, to be
        taken into account in one's deliberations, when seeking to
        determine the conditions obtaining in the field.
 
        These are: (1) The Moral Law; (2) Heaven; (3) Earth; (4) The
        Commander; (5) Method and discipline.
    EOT
    directory_permission = "0777"
    file_permission      = "0777"
    filename             = "art_of_war.txt"
    id                   = "657f681ea1991bc54967362324b5cc9e07c06ba5"
}
```

Kết quả đáng `terraform plan` chỉ đơn thuần là kết quả của việc provider chọn làm điều gì đó hơi kỳ quặc với cách triển khai Read(). Tôi không biết tại sao provider lại chọn làm theo cách đó, nhưng provider đã quyết định rằng nếu nội dung tệp không khớp chính xác với nội dung trong tệp trạng thái thì tài nguyên sẽ không còn tồn tại. Hậu quả là Terraform cho rằng tài nguyên đó không còn tồn tại dù vẫn còn một file có cùng tên. Sẽ không có sự khác biệt khi chạy `terraform apply` vì tệp hiện có sẽ bị ghi đè.

### 2.7.2 Terraform refresh

Làm thế nào chúng ta có thể fix configuration drift? Terraform tự động fix nó nếu chúng ta chạy lệnh `terraform apply`, nhưng đây không phải là một cách đúng đắn. Hãy yêu cầu Terraform điều chỉnh trạng thái mà nó biết với những gì hiện đang được triển khai. Điều này có thể được thực hiện với việc chạy lệnh `terraform refresh`:

Bạn có thể xem việc `terraform refresh` giống như `terraform plan` vì cũng làm thay đổi state file. Tuy nhiên, `terraform refresh` đó là hoạt động chỉ đọc và không sửa đổi cơ sở hạ tầng hiện có được quản lý - nó chỉ sửa đổi file state ở local.

Quay trở lại command line, chạy `terraform refresh` để điều chỉnh lại state file:

```
$ terraform refresh
local_file.literature: Refreshing state... [id=657f681ea1991bc54967362324b5cc9e07c06ba5]
```

Bây giờ hãy tiếp tục chạy lệnh `terraform show` bạn sẽ thấy state file update:
```
$ terraform show
```

Tuy nhiên, đến đây bạn lại không thấy có gì trả về, bởi vì đây là một phần của sự kỳ lạ trong cách hoạt động của local_file (nó khiến tệp cũ không còn tồn tại) ít nhất là bây giờ nó đã nhất quán.

Quay lại command line, chúng ta có thể sửa lại file *art_of_war.txt* cho đúng với lệnh `terraform apply`
```
code here
``` 

Bây giờ, nội dung của file *art_of_war.txt* đã được khôi phục về như cũ (không còn là Napoleon nữa mà là Sun Tzu). Nếu đây là một tài nguyên trên cloud như AWS, GCP hay Azure, thì mọi thay đổi thủ công bằng cách nhấp chuột trên màn hình console sẽ không còn vào thời điểm này nữa. (ví dụ, sửa tag name của EC2, hay một số dịch vụ khác bằng màn hình AWS console chứ không phải sửa bằng Terrform configuration)
```
code here
```

## 2.8 Xoá local_file resource

Sau khi đi qua các bước trên, đã đến lúc chúng ta dọn dẹp tài nguyên bằng việc chạy `terraform destroy`:
```
code here
```

{{< alert type="warning" >}}
Cờ -auto-approve trong lệnh `terraform destroy` cũng tương tự như trong lệnh `terraform apply`, nó tự động approve mà không cần chúng ta phải xác nhận thủ công bằng cách gõ `yes` nữa.
{{< /alert >}}

`terraform destroy` sẽ tạo ra một execution plan và thực hiện Read() trên mỗi resource, sau đó đánh dấu các resource để xoá. Mô tả ở hình 2.11

**Hình 2.11** Các bước Terraform thực hiện tạo ra execution plan khi thực hiện delete
{{<img src="/assets/images/posts/terraform/figure2.11.png" align="left" title="Các bước Terraform thực hiện tạo ra execution plan khi thực hiện delete" >}}


Trong quá trình thực thi việc destroy, Terraform sẽ invoke Delete() hook trên mỗi resource trong state file. Ở bài này, chúng ta chỉ có 1 resource đó là local_file, chính vì vậy Terraform chỉ invoke Delete() trên local_file. Mô tả ở hình 2.12

**Hình 2.12** `terraform destroy` invoke Delete() trên mỗi resource của state file
{{<img src="/assets/images/posts/terraform/figure2.12.png" align="left" title="Terraform destroy invoke Delete() on each resource of state file" >}}

Sau khi thực hiện xong `terraform destroy`, file *art_of_war.txt* đã được xoá. Cấu trúc thư mục hiện tại như sau:
```
code here
```

{{< alert type="info" >}}
Xoá tất cả các nội dung trong configuration file sau đó thực hiện lệnh `terraform apply` cũng tương đương với việc dùng lệnh `terraform destroy`.
{{< /alert >}}

Mặc dù chúng ta thấy đã biến mất, tuy nhiên về mặc nội dung thì vẫn tồn tại một file backup có tên là *terraform.tfstate.backup*. File backup này là bản copy của state file (trước khi destroy) nhằm mục đích lưu trữ để phục hồi trạng thái nếu cần thiết. Chúng ta hoàn toàn có thể xoá nó nếu không cần dùng tới, tuy nhiên theo tôi là nên để lại.

State file hiện tại của chúng ta sẽ như sau:

**Listing 2.6** terraform.tfstate
```
code here
```

Ngoài lề, đây là code của Delete() function trong Local provider

**Listing 2.7** Local file delete
```
code here
```

## 2.9 Tổng kết

Trong chương này, chúng ta đã hiểu sâu hơn về Terraform, cách nó hoạt động, cách nó provisions infrastructure, và cách nó phát hiện các sai lệch về cầu hình giữa state file và hạ tầng thực tế. Terraform về cơ bản là một công cụ quản lý trạng thái để thực hiện hoạt động CURD trên resource. Điểm khác biệt là Terraformm không chỉ triển khai cơ sở hạ tầng: Terraform còn quản lý nó  Terraform hiểu được sự phụ thuộc giữa các tài nguyên và thậm chí có thể phát hiện và sửa lỗi sai lệch cấu hình (configuration drift).

Giá trị của Terraform còn nằm ở số lượng các provider được published và khả dụng trên Terraform registry. 

Trong chương tiếp theo, chúng ta sẽ tìm hiểu thêm 2 provider mới đó là **Random** và **Archive**:

**Summary**

- **Local** provider cho phép chúng ta tạo và quản lý tệp văn bản trên máy local của mình. Với mục đích học tập, chúng ta có thể sử dụng Local provider như một phương pháp để mapping giữa local với infrastructure thực tế.
- Các resource được tạo theo một trình tự nhất định theo execution plan. Trình tự được tính toán tự động dựa trên sự phụ thuộc ngầm định giữa các resource (implicit dependencies).
- Mỗi resource có vòng đời gọi là **life cycle function hooks** liên kết với nó: `Create()`, `Read()`, `Update()`, `Delete()`. Terraform sẽ invoke các function này như một phần của quá trình vận thành thông thường.
- Thay đổi configuration code, chạy `terraform apply` sẽ giúp update các resource đã tồn tại và đang được quản lý bởi Terraform. Chúng ta cũng có thể sử dụng `terraform refresh` để update state file dựa trên thông tin triển khai mới nhất của hạ tầng (difting configuration)
- Terraform đọc state file trong quá trình lập kế hoạch (plan) để quyết định hành động nào sẽ được thực hiện khi `apply`. Chúng ta không được làm mất state file vì nếu mất, Terraform sẽ không thể theo dõi được các tài nguyên mà nó đang quản lý nữa.

