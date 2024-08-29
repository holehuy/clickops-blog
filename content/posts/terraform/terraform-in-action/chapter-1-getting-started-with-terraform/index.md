---
title: "Chapter 1 - Getting started with Terraform"
date: 2024-08-14T06:00:20+06:00
hero: /images/posts/terraform/figure1-2-deploying-to-multiple-clouds-concurrently-with-terraform.png
description: "Chapter 1 - Getting started with Terraform"
menu:
  sidebar:
    name: "Chapter 1 - Getting started with Terraform"
    identifier: chapter-1
    parent: terraform-in-action
    weight: 10
---

> **Nội dung:**
> 1. Tìm hiểu cú pháp HCL
> 2. Các thành phần cơ bản và cách tạo một block trong Terraform
> 3. Thiết lập Terraform workspace
> 4. Cấu hình và triển khai EC2 AWS

Terraform là một công nghệ/công cụ triển khai cho bất kì cá nhân hoặc tổ chức nào muốn provision (cung cấp) và manager (quản lý) hạ tầng công nghệ thông tin dưới dạng mã - hay thường được gọi với cái tên Infrastructure as Code (IaC). Từ ***Infrastruture*** ở đây đang chủ yếu đề cập đến cơ sở hạ tầng điện toán đám mây (cloud-based infrastructure). 

***Infrastruture as Code*** là quá trình chúng ta quản lý và cung cấp cơ sở hạ tầng thông qua các tệp định nghĩa mà máy tính có thể đọc được. Chúng ta thường sử dụng IaC để tự động hoá các quy trình mà trước đây được thực hiện thủ công.

Khi chúng ta nói đến *provisioning* là chúng ta đang nói đến việc triển khai cơ sở hạ tầng. Trái ngược với ***configuration management*** liên quan đến phân phối các ứng dụng trên các máy ảo (virtual machines). Các Configuration Management Tools ví dụ như Asible, Puppet, SaltStack và Chef đã từng cực kỳ phổ biến và tồn tại trong nhiều năm liền. Terraform ra đời không nhằm mục đích thay thế các công cụ này vì cơ bản cung cấp cơ sở hạ tầng (infrastructure provisioning) và quản lý cấu hình (configuration management) là 2 vấn đề hoàn toàn khác nhau. 

Terraform cho phép chúng ta biết các mã human-readable để xác định các cấu hình của chúng ta. Với Terraform IaC chúng ta có thể triển khai trên các public cloud, private cloud, hoặc hybrid cloud với các đặc điểm sau:

- Consistent environments (các môi trường nhất quán)
- Repeatable (có thể lặp đi lặp lại)
- Ephemeral (tạm thời)

**Hình 1.1** Terraform có thể triển khai hạ tầng trên bất cứ nền tảng điện toán đám mây nào
{{<img src="/assets/images/posts/terraform/figure1-1-teraform-can-deploy-infra-to-any-cloud.jpg" align="center" title="Terraform có thể triển khai hạ tầng trên bất cứ nền tảng điện toán đám mây nào" >}}

Trong bài viết này chúng ta sẽ điểm qua một số đặc điểm nổi bật của Terraform. Cùng nhau so sánh về ưu nhược điểm của Terraform so với các công nghệ IaC khác và điều gì khiến cho Terraform là người chiến thằng trong cuộc đua IaC (tính đến thời điểm hiện tại). Cuối cùng là phần hands on lab bằng việc triển khai 1 máy chủ EC2 trên AWS kết hợp với một vài tính năng của Terraform.

## 1.1 Điều gì khiến Terraform trở thành một công cụ tuyệt vời

Có rất nhiều lời khen hoa mỹ dành cho Terraform tuy nhiên không phải cái nào cũng chính xác. Và Terraform cũng không phải là công nghệ duy nhất trong hàng tá công nghệ về IaC cũng làm điều tương tự. Làm thế nào công nghệ này thích nghi và có khả năng cạnh tranh với gần như tất cả những ông lớn về Cloud như Amazon, Microsoft, Google? 

Các đặc điểm chính dưới đây đã làm Terraform trở nên tuyệt vời và mang lại lợi thế cạnh tranh:

- **Provisioning Tool** - Triển khai hạ tầng (infrastructure) chứ không chỉ có mỗi applications
- **Easy to use** (Dễ dùng)
- **Free and open source** - 
- **Declarative** (Khai báo) - Chỉ cần trình bày cái bạn muốn và cách thực hiện, phần còn lại Terraform sẽ làm
- **Cloud-agnostic** (Mình chưa tìm được từ nào để dịch sát nghĩa từ này nên xin phép nêu ra một vài định nghĩa ở đây) - Cloud-agnostic mục đích dùng để thiết kế các ứng dụng có thể chạy liền mạch trên tất cả các nhà cung cấp dịch vụ Cloud nào. Không giống như ứng dụng Cloud-native, Cloud-agnostic không phụ thuộc vào bộ công cụ của một nền tảng Cloud duy nhất, thay vào đó chúng kết hợp với nhau thông qua các công cụ mã nguồn mở hoặc các công cụ của nhà cung cấp Cloud. Tính chất này nhằm thể hiện rằng chúng ta có thể dùng Terraform để deploy hạ tầng trên bất kỳ Cloud nào.
- **Extendable** - Có thể mở rộng

> **So sánh**
> 
>**Pulumi**: là một nền tảng IaC tương tự như Terraform, điểm khác biệt là Pulumi không có tính chất Declarative (Khai báo) mà là Imperative (mệnh lệnh)
>
>**AWS Cloudformation**: Là nguồn cảm hứng ban đầu của Terraform, và có thể coi là anh em họ với GCP Deployment Manager và Azure Resource Manager. Những công nghệ này mặc dù rất tốt những không có tính chất Cloud-agnostic. Tức là bạn không dùng AWS Cloudformationd để provisioning infrastruture trên Azure hoặc đại loại như vậy.
>
>**Ansible, Chef, Puppet và SaltStack**: là các công cụ Configuration Management (CM), trái ngược với các công cụ cung cấp cơ sở hạ tầng. Chúng giải quyết một loại vấn đề hơi khác so với Terraform. 

### 1.1.1 Provisioning Tool

Terraform là một Infrastruture Provisioning Tool, không phải là một CM tool. Provisioning Tool triển khai và quản lý hạ tầng, trong khi đó Configuration Management (CM) như Ansible, Puppet, SaltStack và Chef triển khai phần mềm lên các máy chủ hiện có. Một vài CM tool cũng có thể thực hiện được việc cung cấp hạ tầng, tuy nhiên không làm tốt bằng Terraform. 

Sự khác biệt giữa CM và provisioning tools là: CM tools thiên về mutable infrastructure, còn Terraform và các provisioning tools khác thiên về immutable infrastructure.

***Mutable infrastructure*** - Cơ sở hạ tầng có thể thay đổi, có nghĩa là có nghĩa là bạn thực hiện cập nhật phần mềm trên các máy chủ hiện có.

***Immutable infrastructure*** - Cơ sở hạ tầng bất biến là cơ sở hạ tầng ít có khả năng thay đổi sau khi triển khai, thay vào đó khi cần thay đổi thì hạ tầng sẽ được thay thế bằng một phiên bản mới.

### 1.1.2 Dễ dùng

Các kiến thức cơ bản của Terraform nhìn chung là dễ học, cho dù bạn là người mới cũng có thể nắm bắt được các nội dung này. Lý do chính khiến Terraform dễ sử dụng là do mã được viết bằng ngôn ngữ cấu hình riêng có tên là ***HashiCorp Configuration Language*** (HCL). Đây là ngôn ngữ được HashiCorp cho ra đời để thay thế các ngôn định dạng ngôn ngữ cấu hình dài dòng hơn như là XML hoặc JSON. Cân bằng giữa khả năng đọc của con người và máy tính và được phát triển bởi sự ảnh hưởng của một vài công nghệ đi trước (Nginx, lubcl, ...).

HCL hoàn toàn tương thích với JSON, tức là HCL có thể được chuyển đổi 1:1 thành JSON và ngược lại. Điều này giúp cho chúng ta dễ dàng thực hiện các tác vụ khác bên ngoài phạm vi Terraform.

### 1.1.3 Declarative programing

**Declarative programing** - Lập trình khai báo có nghĩa là bạn thể hiện logic của một phép tính dưới dạng là cái gì đó, mà không mô tả luồng điều khiển là cách nào để tạo ra nó. Thay vì viết hướng dẫn từng bước, bạn chỉ cần mô tả những gì bạn muốn. Ví dụ về ngôn ngữ lập trình khai báo bao gồm ngôn ngữ truy vấn cơ sở dữ liệu (SQL), ngôn ngữ lập trình chức năng (Haskell, Clojure), ...

Trái ngược với nó là *Imperative programing*, chúng ta sẽ sử dụng các câu lệnh điều kiện, vòng lặp, các phép tính để kiểm soát luồng điều khiển, lưu trữ trạng thái và thực thi các câu lệnh. Các ngôn ngữ truyền thống hiện nay hầu như đều là imperative (Python, Java, ...).

Tính chất Declarative của Terraform được thể hiện như sau:
1. **Mô tả trạng thái mong muốn**: Với Terraform, bạn không cần phải viết code để chỉ ra từng bước cụ thể để tạo ra một tài nguyên. Thay vào đó, bạn chỉ cần mô tả trạng thái mong muốn của tài nguyên, ví dụ như một máy ảo với những cấu hình nhất định.
2. **Tự động suy luận và triển khai**: Dựa trên mô tả của bạn, Terraform sẽ tự động phân tích, suy luận và thực hiện các bước cần thiết để triển khai tài nguyên đó. Nó sẽ tự động tạo, cấu hình và liên kết các tài nguyên cần thiết.
3. **Idempotent**: Khi bạn chạy lại Terraform với cùng một mô tả, nó sẽ kiểm tra trạng thái hiện tại và chỉ thực hiện những thay đổi cần thiết để đưa hệ thống về trạng thái mong muốn. Điều này giúp Terraform trở nên idempotent.
4. **Khả năng mô tả phức tạp**: Với tính chất declarative, Terraform cho phép bạn mô tả các tài nguyên phức tạp, bao gồm cả mối quan hệ giữa chúng. Ví dụ, bạn có thể mô tả cả virtual network, subnet, máy ảo và liên kết chúng với nhau.
5. **Tái sử dụng và chia sẻ**: Nhờ vào cách mô tả declarative, các mô tả Terraform có thể dễ dàng được tái sử dụng hoặc chia sẻ giữa các nhóm/dự án.

{{< alert type="info" >}}
**Declarative programings** quan tâm đến kết quả chứ không quan tâm đến quá trình, còn **Imperative programing** quan tâm đến quá trình hơn là kết quả.
{{< /alert >}}

### 1.1.4 Cloud-agnostic

Cloud-agnostic có nghĩa là có thể chạy liền mạch trên bất kỳ nền tảng cloud nào bằng cách sử dụng cùng một bộ công cụ và workflows. Terraform không phụ thuộc vào Cloud vì chúng ta có thể triển khai cơ sở hạ tầng lên AWS một cách dễ dàng như với GCP, Azure hoặc thậm chí là private datacenter (Hình 1.2). Chúng ta sẽ không bị ràng buộc vào một nhà cung cấp Cloud cụ thể và không phải học một công nghệ hoàn toàn mới mỗi khi bạn chuyển đổi nhà cung cấp Cloud.

**Hình 1.2** Triển khai trên nhiều nền tảng cloud khác nhau với Terraform
{{<img src="/assets/images/posts/terraform/figure1-2-deploying-to-multiple-clouds-concurrently-with-terraform.png" align="center" title="Triển khai trên nhiều nền tảng cloud khác nhau với Terraform" >}}

Terraform tích hợp với các cloud khác nhau thông qua các **Terraform providers**. **Provider** là các plugin dành cho Terraform được thiết kế để tương tác với API bên ngoài. Mỗi nhà cung cấp cloud sẽ duy trì và phát triển Terraform provider của riêng mình, cho phép Terraform quản lý tài nguyên trong cloud đó. Providers được viết bằng golang và được phân phối dưới dạng binaries trên [Terraform Registry](https://registry.terraform.io). Nó sẽ xử lý tất cả logic về authenticating, thực hiện các yêu cầu API cũng như xử lý lỗi,... Có nhiều providers khác nhau và mỗi provider thì cung cấp cho chúng ta khả năng quản lý các loại tài nguyên khác nhau.

Chúng ta cũng có thể tự tạo ra provider cho riêng mình. Mình sẽ khám phá ở [Chapter 11]().

### 1.1.5 Các biểu thức tính toán phong phú và có khả năng mở rộng cao

Terraform có các biểu thức tính toán phong phú và có khả năng mở rộng cao khi chúng ta mang nó so sánh với các công cụ Declarative IaC khác. Với các conditionals, for loop, template files, dynamic block, variables, và nhiều built-in function khác, ta có thể dễ dàng viết code để thực hiện chính xác những gì mình muốn.

## 1.2 "Hello Terraform!"

Trong phần này chúng ta sẽ thực hành một case kinh điển khi làm việc với Cloud bằng Terraform: triển khai máy ảo EC2 Instance trên AWS. Sử dụng AWS Provider để Terraform thay mặt chúng ta call API và triển khai EC2 Instance. Khi triển khai thành công, chúng ta sẽ yêu cầu Terraform gỡ bỏ EC2 instance để không phải tốn thêm chi phí khi sử dụng EC2 instance này cho mục đích thực hành.. Hình 1.3 thể hiện architecture diagram của phần thực hành này.

**Hình 1.3** Sử dụng Terraform để deploy 1 EC2 instance lên AWS
{{<img src="/assets/images/posts/terraform/figure1-3-using-terraform-to-deploy-an-ec2-instance-to-aws.png" align="center" title="Sử dụng Terraform để deploy 1 EC2 instance lên AWS" >}}

Để làm được bài thực hành này, bạn cần cài đặt Terraform và cần phải có AWS credentials. Hướng dẫn chi tiết phần cài đặt tại [đây](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

Các bước để triển khai như sau:

1. Viết Terraform configuration files.
2. Cấu hình AWS provider.
3. Initialize Terraform với `terraform init`.
4. Deploy EC2 instance với `terraform apply`.
5. Clean up resource với `terraform destroy`.

**Hình 1.4** Sequence diagram của các bước triển khai bài thực hành "Hello Terraform!"
{{<img src="/assets/images/posts/terraform/figure1-4-sequence-diagram-of-hello-world-deployment.png" align="center" title="Sequence diagram của các bước triển khai bài thực hành" >}}

### 1.2.1 Terraform configuration files

Terraform sẽ đọc configuration files để có thể triển khai infrastructure, chúng ta sẽ "nói" với Terraform rằng "Tôi muốn deploy một EC2 instance" -> chúng ta cần mô tả EC2 Instance đó bằng code.

Bắt đầu bằng việc tạo 1 file mới có tên là main.tf với nội dung bên dưới. Đuôi `.tf` là định dạng của Terraform configuration file. Khi Terraform thực thi, nó sẽ đọc tất cả các file trong working directory những file nào có đuôi là `.tf` và sẽ nối chúng lại với nhau.

{{< alert type="info" >}}
Tất cả code trong series này đều có thể truy cập được trên GitHub repo [này](https://github.com/terraform-in-action/manning-code) nếu bạn cần.
{{< /alert >}}

**Listing 1.1** Nội dung của main.tf
```
resource "aws_instance" "helloworld" {
  ami           = "ami-09dd2e08d601bff67"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}

```
{{< alert type="info" >}}
Amazon Machine Image (AMI) id ở trên ở region us-west-2
{{< /alert >}}

Code trong Listing 1.1 mô tả chúng ta muốn Terraform cung cấp cho chúng ta 1 EC2 instance type *t2.micro* với Ubuntu AMI và name tag. Tiến hành so sánh với đoạn code tương đương với CloudFormation (AWS), chúng ta có thể thấy rằng cú pháp của Terraform rõ ràng và ngắn gọn hơn:

```
{
    "Resources": {
        "Example: {
            "Type": "AWS::EC2::Instance",
            "Properties": {
                "ImageId": "ami-09dd2e08d601bff67",
                "InstanceType": "t2.micro",
                "Tags": [
                    {
                        "Key": "Name",
                        "Value": "HelloWorld"
                    }
                ]
            }
        }
    }
}
```

Code block trong file main.tf ở trên là ví dụ cho Terraform ***resource***. Terraform resources một trong những thành phần quan trọng nhất trong Terraform, nó cung cấp các hạ tầng như VMs, Load Balancers, NAT Gateway,... Các **resource** được mô tả dưới dạng HCL object với element name là *resource* và có chính xác là hai labels. Label đầu tiên (Type) cho xác định resource bạn sẽ tạo là gì (ec2, nat gateway, hay là s3 bucket, ...). Label thứ 2 (Name) là resource name (đặt tên cho resource của bạn). Tên này không có ý nghĩa đặc biệt và chỉ được sử dụng để tham chiếu tài nguyên trong phạm vi mô-đun nhất định (chúng ta sẽ nói về phạm vi mô-đun trong chương 4). Khi ghép lại với nhau, Type và Name tạo nên mã định danh tài nguyên (Resource Identifier), duy nhất cho mỗi tài nguyên. Hình 1.5 thể hiện cú pháp của *resoure block* trong Terraform.

**Hình 1.5** Cú pháp của resource block
{{<img src="/assets/images/posts/terraform/figure1-5-syntax-of-a-resource-block.png" align="center" title="Cú pháp của resource block" >}}

Mỗi **resource** đều có đầu vào (inputs) và đầu ra (outputs). Đầu vào được gọi là **arguments** và đầu ra được gọi là **attributes**. **Arguments** được truyền vào resource và cũng có sẵn dưới dạng **attributes** của resource. Ngoài ra còn có các **computed attributes** chỉ khả dụng sau khi tài nguyên được tạo. Computed attributes chứa thông tin sau khi tính toán của tài nguyên đó. Hình 1.6 hiển thị các arguments, attributes và computed attributes mẫu cho tài nguyên *aws_instance*

**Hình 1.6** Ví dụ về inputs và outputs cho 1 *aws_instance* resource
{{<img src="/assets/images/posts/terraform/figure-1-6-sample-inputs-and-outputs-for-an-aws-instance-resource.png" align="center" title="Ví dụ về inputs và outputs cho aws_instance resource" >}}


### 1.2.2 Cấu hình AWS provider

Tiếp theo chúng ta cần cấu hình AWS provider. AWS provider chịu trách nhiệm cho các tương tác API, gửi các authenticated request và cung cấp tài nguyên cho Terraform. Để cấu hình AWS provider, chúng ta thêm một *provider* block. Chỉnh sửa code trong main.tf như hình bên dưới

**Listing 1.2** main.tf
```
provider "aws" {
  region  = "us-west-2"
}
 
resource "aws_instance" "helloworld" {
  ami           = "ami-09dd2e08d601bff67"
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}
```

{{< alert type="info" >}}
Bạn cần phải có AWS credentials trước khi có thể provision infrastructure. Chúng có thể được lưu trữ trong một credentials file hoặc dưới dạng biến môi trường. Tham khảo [Appendix A]() để xem chi tiết hướng dẫn
{{< /alert >}}

Không giống như resources, providers chỉ có duy nhất một label là *Name*. Đây là tên chính thức của một provider được publish trên Terraform Registry (ví du: "aws" cho AWS, "google" cho GCP, "azurerm" cho Azure). Cú pháp của một provider block được thể hiện ở Hình 1.7.

**Hình 1.7** Cú pháp của một provider block
{{<img src="/assets/images/posts/terraform/figure-1-7-syntax-of-a-provider-block.png" align="left" title="Cú pháp của một provider block" >}}

{{< alert type="info" >}}
Terraform Registry là một nơi để chia sẻ các provider binaries. Khi Terraform khởi tạo, nó sẽ tự động tìm và download các required provider từ registry.
{{< /alert >}}

Provider không có outputs đầu ra, chỉ có inputs thôi. Bạn cấu hình một provider bằng cách truyền vào inputs (trong trường hợp này gọi là*configuration arguments*) vào provider block. Configuration arguments là những thứ như service endpoint URL, region, provider version, cũng như mọi thông tin xác thực (credentials) cần thiết để xác thực khi call API. Quá trình này được minh họa trong Hình 1.8

**Hình 1.8** Cách provider đưa credential vào *aws_instance* khi call api đến service endpoint của AWS cloud
{{<img src="/assets/images/posts/terraform/figure-1-8-how-provider-inject-credential-into-api-calls.png" align="center" title="Cách provider đưa credential vào aws_instance khi call api đến service endpoint của AWS cloud" >}}

Thông thường, bạn sẽ không muốn đưa các secrets vào provider dưới dạng plaintext, đặc biệt là trong trường hợp thực tế, các code của chúng ta có thể được lưu trữ ở các version control system như GitHub, Bitbucket,... Vì vậy nhiều **provider** cho phép chúng ta đọc các biến môi trường [(environment variable)]() hoặc các credential file. Nếu bạn quan tâm đến việc quản lý các secret, hãy đọc [Chapter 13](), sẽ đề cập chi tiết hơn về chủ đề này.

### 1.2.3 Initializing Terraform

Trước khi triển khai terraform phiên bản EC2, chúng ta phải khởi tạo workspace - không gian làm việc. Mặc dù chúng ta đã khai báo AWS provider nhưng Terraform vẫn cần tải và cài đặt tệp nhị phân từ Terraform Register. Cần phải khởi tạo ít nhất một lần cho tất cả các workspace.

Bạn có thể thực hiện khởi tạo Terraform bằng cách run command `terraform init`. Khi bạn thực hiện lệnh này, bạn sẽ thấy các output sau trên màn hình terminal
```
$ terraform init
 
Initializing the backend...
 
Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.28.0...
- Installed hashicorp/aws v3.28.0 (signed by HashiCorp)
 
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

{{< alert type="info" >}}
Bạn cần phải cài đặt Terraform trên máy tính của bạn, nếu chưa cài đặt thì command trên sẽ không hoạt động
{{< /alert >}}

### 1.2.4 Deploy EC2 instance

Bây giờ chúng ta đã sẵn sàng sử dụng Terraform để triển khai một EC2 instance. Bằng cách run command `terraform apply`

{{< alert type="warning" >}}
Thực hiện hành động này, tài khoản AWS của bạn có thể bị tính phí khi sử dụng EC2 và CloudWatch Logs.
{{< /alert >}}


```
$ terraform apply
```
{{< alert type="danger" >}}
Nếu bạn nhận được một error "No Valid Credentials Sources Found", tức là Terraform đang không thế xác thực được với AWS. Đọc Appendix A để xem hướng dẫn cách lấy credentials và cấu hình AWS provider.
{{< /alert >}}


Outputs của CLI được gọi là ***excution plan*** và mô tả các hành động mà Terraform dự định sẽ thực hiện để đạt trạng thái mong muốn của bạn. Đây là một ý tưởng không tồi, chúng ta cần nên xem lại kế hoạch một cách kĩ càng, tỉnh táo trước khi tiếp tục thực hiện. Không nên có bất kỳ lỗi lạ nào ở bước này. Khi bạn xem xét xong *execution plan*, hãy approve bằng cách nhập `yes` vào command line.

Sau một hoặc hai phút (khoảng thời gian cần để cung cấp phiên bản EC2), quá trình `apply` sẽ hoàn tất.

```
aws_instance.helloworld: Creating...
aws_instance.helloworld: Still creating... [10s elapsed]
aws_instance.helloworld: Still creating... [20s elapsed]
aws_instance.helloworld: Creation complete after 25s [id=i-070098fcf77d93c54]
 
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Bạn có thể kiểm tra resource của bạn đã thành công trên AWS bằng cách truy cập vào AWS Console và navigate sang EC2 như Hình 1.9. Lưu ý rằng instance này đang ở region us-west-2 bởi vì chúng ta đã set trong provider.

**Hình 1.9** EC2 instance đã triển khai trên AWS console
{{<img src="/assets/images/posts/terraform/figure1-9-the-ec2-instance-in-the-aws-console.png" align="center" title="EC2 instance đã triển khai trên AWS console" >}}

Tất cả thông tin trạng thái của resources sẽ được lưu trữ trong một tệp có tên *terraform.tfstate*. Đừng để phần mở rộng *.tfstate* làm bạn thấy lạ lẫm - nó thực sự chỉ là một tệp JSON. `terraform show` command có thể được sử dụng để in human-readable output từ state file và giúp dễ dàng liệt kê thông tin về các tài nguyên mà Terraform quản lý. Minh hoạ về kết quả của `terraform show` như bên dưới:
```
$ terraform show
# aws_instance.helloworld:
resource "aws_instance" "helloworld" {
    ami                          = "ami-09dd2e08d601bff67"
    arn                          = 
       ➥ "arn:aws:ec2:us-west-2:215974853022:instance/i-070098fcf77d93c54"
    associate_public_ip_address  = true
    availability_zone            = "us-west-2a"
    cpu_core_count               = 1
    cpu_threads_per_core         = 1
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false
    id                           = "i-070098fcf77d93c54"
    instance_state               = "running"
    instance_type                = "t2.micro"
    ipv6_address_count           = 0
    ipv6_addresses               = []
    monitoring                   = false
    primary_network_interface_id = "eni-031d47704eb23eaf0"
    private_dns                  = 
       ➥ "ip-172-31-25-172.us-west-2.compute.internal"
    private_ip                   = "172.31.25.172"
    public_dns                   = 
       ➥ “ec2-52-24-28-182.us-west-2.compute.amazonaws.com”
    public_ip                    = “52.24.28.182”
    secondary_private_ips        = []
    security_groups              = [
        “default”,
    ]
    source_dest_check            = true
    subnet_id                    = “subnet-0d78ac285558cff78”
    tags                         = {
        “Name” = “HelloWorld”
    }
    tenancy                      = “default”
    vpc_security_group_ids       = [
        “sg-0d8222ef7623a02a5”,
    ]
 
    credit_specification {
        cpu_credits = “standard”
    }
 
    enclave_options {
        enabled = false
    }
 
    metadata_options {
        http_endpoint               = “enabled”
        http_put_response_hop_limit = 1
        http_tokens                 = “optional”
    }
 
    root_block_device {
        delete_on_termination = true
        device_name           = “/dev/sda1”
        encrypted             = false
        iops                  = 100
        tags                  = {}
        throughput            = 0
        volume_id             = “vol-06b149cdd5722d6bc”
        volume_size           = 8
        volume_type           = “gp2”
    }
}
```

Ở đây có nhiều attributes hơn chúng ta đặt ban đầu trong resource block vì hầu hết các attribute của aws_instance đều là *optional* hoặc là *computed attribute*. Bạn có thể tùy chỉnh aws_instance bằng cách đặt một số optional argument. Hãy tham khảo tài liệu của AWS provider để biết thêm tại [đây](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).

### 1.2.5 Dọn dẹp tài nguyên

Đã đến lúc nói lời tạm biệt với EC2 instance. Bạn sẽ cần dọn dẹp cơ sở hạ tầng mà bạn không còn sử dụng nữa bởi vì việc sử dụng các tài nguyên trên cloud sẽ tốn tiền. Terraform có một command đặc biệt để dọn dẹp tất cả tài nguyên: `terraform destroy`. Khi bạn chạy lệnh này, bạn sẽ được nhắc để xác nhận destroy một cách thủ công:
```
$ terraform destroy
aws_instance.helloworld: Refreshing state... [id=i-070098fcf77d93c54]
 
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  - destroy
 
Terraform will perform the following actions:
 
  # aws_instance.helloworld will be destroyed
  - resource “aws_instance” “helloworld” {
      - ami                          = "ami-09dd2e08d601bff67" -> null
      - arn                          = "arn:aws:ec2:us-west-2:215974853022:
instance/i-070098fcf77d93c54" -> null
      - associate_public_ip_address  = true -> null
      - availability_zone            = "us-west-2a" -> null
      - cpu_core_count               = 1 -> null
      - cpu_threads_per_core         = 1 -> null
      - disable_api_termination      = false -> null
      - ebs_optimized                = false -> null
      - get_password_data            = false -> null
      - hibernation                  = false -> null
      - id                           = "i-070098fcf77d93c54" -> null
      - instance_state               = "running" -> null
      - instance_type                = "t2.micro" -> null
      - ipv6_address_count           = 0 -> null
      - ipv6_addresses               = [] -> null
      - monitoring                   = false -> null
      - primary_network_interface_id = "eni-031d47704eb23eaf0" -> null
      - private_dns                  = 
              ➥ "ip-172-31-25-172.us-west-2.compute.internal" -> null
      - private_ip                   = “172.31.25.172” -> null
      - public_dns                   = 
              ➥ “ec2-52-24-28-182.us-west-2.compute.amazonaws.com” -> null
      - public_ip                    = "52.24.28.182" -> null
      - secondary_private_ips        = [] -> null
      - security_groups              = [
          - "default",
        ] -> null
      - source_dest_check            = true -> null
      - subnet_id                    = "subnet-0d78ac285558cff78" -> null
      - tags                         = {
          - “Name” = “HelloWorld”
        } -> null
      - tenancy                      = “default” -> null
      - vpc_security_group_ids       = [
          - “sg-0d8222ef7623a02a5”,
        ] -> null
 
      - credit_specification {
          - cpu_credits = “standard” -> null
        }
 
      - enclave_options {
          - enabled = false -> null
        }
 
      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
        }
 
      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/sda1" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - tags                  = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-06b149cdd5722d6bc" -> null
          - volume_size           = 8 -> null
          - volume_type           = “gp2” -> null
        }
    }
 
Plan: 0 to add, 0 to change, 1 to destroy.
 
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only ‘yes’ will be accepted to confirm.
 
  Enter a value:
```

{{< alert type="warning" >}}
Điều quan trọng là KHÔNG chỉnh sửa hoặc xóa tệp terraform.tfstate theo cách thủ công, nếu không Terraform sẽ mất dấu vết các resource được quản lý và có thể dẫn đến những sai sót không đáng có.
{{< /alert >}}

*Destroy plan* cũng giống như *execution plan* trước đó, chỉ khác là đây là các công việc dự định cho thao tác xoá mà thôi.

{{< alert type="info" >}}
`terraform destroy` thực hiện chính xác điều tương tự khi bạn xóa tất các code của mình sau đó chạy `terraform apply`.
{{< /alert >}}

Đẻ xác nhận rằng bạn muốn áp dụng *destroy plan* bằng cách gõ `yes` tại dấu nhắc. Đợi vài phút để Terraform giải quyết công việc destroy, sau đó bạn sẽ được thông báo Terraform đã hủy xong toàn bộ tài nguyên. Output của bạn sẽ trông như sau:
```
aws_instance.helloworld: Destroying... [id=i-070098fcf77d93c54]
aws_instance.helloworld: Still destroying... 
➥ [id=i-070098fcf77d93c54, 10s elapsed]
aws_instance.helloworld: Still destroying... 
➥ [id=i-070098fcf77d93c54, 20s elapsed]
aws_instance.helloworld: Still destroying... 
➥ [id=i-070098fcf77d93c54, 30s elapsed]
aws_instance.helloworld: Destruction complete after 31s
 
Destroy complete! Resources: 1 destroyed.
```

Bạn có thể kiểm tra thử tài nguyên thực sự đã được destroy chưa bằng cách kiểm tra trên AWS console hoặc chạy `terraform show` và nếu nó không trả về dữ liệu gì thì chúng ta đã hoàn thành việc destroy infrastructure:
```
$ terraform destroy
```

## 1.3 Khoát áo đẹp cho "Hello Terraform!"

"Hello World!" là một dự án tốt, nhưng chưa đủ. Terraform có thể làm được nhiều việc hơn là chỉ cung cấp tài nguyên từ các code tĩnh. Nó cũng có thể cung cấp tài nguyên một cách linh hoạt dựa trên kết quả của các truy vấn bên ngoài và tra cứu dữ liệu. Bây giờ chúng ta hãy tìm hiểu **data sources**, là các thành phần cho phép bạn tìm nạp dữ liệu tại runtime và thực hiện tính toán.

Trong phần này, chúng ta sẽ cải thiện Hello World project ở trên bằng cách *data source* để tự động lấy gía trị mới nhất của Ubuntu AMI. Sau đó đưa giá trị này vào *aws_instance* để không phải hardcode AMI trong cấu hình của EC2 Instance (Hình 1.10).

Bởi vì chúng ta đã hoàn thành bước cấu hình AWS provider và khởi tạo Terraform với `terraform init`, nên có thể bỏ qua các bước đã làm ở trên. Các bước cần làm bây giờ là:
1. Chỉnh sửa Terraform configuration để thêm data source.
2. Re-deploy với `terraform apply`.
3. Dọn dẹp tài nguyên với `terraform destroy`.

**Hình 1.10** Cách truyền output của *aws_ami* vào inputs *aws_instance* resource
{{<img src="/assets/images/posts/terraform/figure1-10-how-the-output-aws-ami-chained-to-input-of-aws-instance.png" align="center" title="Cách truyền output của aws_ami vào inputs aws_instance resource" >}}

Quy trình này được mô tả ở Hình 1.11.

**Hình 1.11** Deployment sequence diagram
{{<img src="/assets/images/posts/terraform/figure1-11-deployment-sequence-diagram.png" align="center" title="Deployment sequence diagram" >}}

### 1.3.1 Chỉnh sửa Terraform configuration

Chúng ta cần thêm mã để đọc từ nguồn dữ liệu bên ngoài, cho phép truy vấn Ubuntu AMI gần đây nhất được xuất bản lên AWS. Chỉnh sửa main.tf để trông giống bên dưới

**Listing 1.3** main.tf
```
provider "aws" {
  region = "us-west-2"
}
 
data "aws_ami" "ubuntu" {
  most_recent = true
 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
 
  owners = ["099720109477"]
}
 
resource "aws_instance" "helloworld" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}
```

Giống như **resource**, **data source** cũng được mô tả bằng HCL object với type "data" và có 2 label. Lable thứ nhất (Type) xác định kiểu của data source. Label thứ hai (Name) là tên của data source. Kết hợp Type và Name chúng ta sẽ có mã định danh của data source. Mã định danh này là duy nhất trong một module. Hình 1.12 mô tả cú pháp của một data source.

**Hình 1.12** Cú pháp của một data source
{{<img src="/assets/images/posts/terraform/figure1-12-syntax-of-a-data-resource.png" align="center" title="Cú pháp của một data source" >}}

Nội dung của một data source code block được gọi là ***query constraint argument***. Chúng hoạt động giống hệt như các argument của resource. Query constraint argument được sử dụng để chỉ định resource để tìm nạp dữ liệu. Data source là các tài nguyên mà Terraform chỉ có thể đọc dữ liệu chứ không trực tiếp kiểm soát.

1.3.2 Apply các thay đổi

Hãy tiếp tục và áp dụng các thay đổi để triển khai một EC2 instance với AMI được lấy từ output của data source. Chạy lệnh `terraform apply` và output sẽ nhận được như sau:
```
$ terraform apply
 
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create
 
Terraform will perform the following actions:
 
  # aws_instance.helloworld will be created
  + resource "aws_instance" "helloworld" {
      + ami                          = "ami-0928f4202481dfdf6"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
     // skip some logs
    }
 
Plan: 1 to add, 0 to change, 0 to destroy.
 
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.
 
  Enter a value:
```


Apply các thay đổi bằng cách gõ `yes` vào command line. Sau một vài phút chúng ta sẽ nhận được output như hình bên dưới:
```
aws_instance.helloworld: Creating...
aws_instance.helloworld: Still creating... [10s elapsed]
aws_instance.helloworld: Creation complete after 19s [id=i-0c0a6a024bb4ba669]
 
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

Bạn có thể kiểm tra các thay đổi của mình bằng cách navigate sang AWS console EC2 hoặc chạy lệnh `terraform show`.

### 1.3.3 Dọn dẹp hạ tầng

Cũng như bước trước, chúng ta cũng chỉ cần run `terraform destroy`. Bạn sẽ nhận được lời nhắc xác nhận:
```
$ terraform destroy
aws_instance.helloworld: Refreshing state... [id=i-0c0a6a024bb4ba669]
 
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  - destroy
 
Terraform will perform the following actions:
 
  # aws_instance.helloworld will be destroyed
  - resource "aws_instance" "helloworld" {
      - ami                          = "ami-0928f4202481dfdf6" -> null
      - arn                          = "arn:aws:ec2:us-west-2:215974853022
      ➥ :instance/i-0c0a6a024bb4ba669" -> null
      - associate_public_ip_address  = true -> null
// skip some logs
    }
 
Plan: 0 to add, 0 to change, 1 to destroy.
 
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.
 
  Enter a value:
```

Sau khi xác nhận bằng cách gõ `yes` vào command line thì sau vài phút EC2 instance cũng sẽ được xoá:
```
aws_instance.helloworld: Destroying... [id=i-0c0a6a024bb4ba669]
aws_instance.helloworld: Still destroying... 
➥ [id=i-0c0a6a024bb4ba669, 10s elapsed]
aws_instance.helloworld: Still destroying... 
➥ [id=i-0c0a6a024bb4ba669, 20s elapsed]
aws_instance.helloworld: Still destroying... 
➥ [id=i-0c0a6a024bb4ba669, 30s elapsed]
aws_instance.helloworld: Destruction complete after 30s
 
Destroy complete! Resources: 1 destroyed.
```

## 1.4 Tổng kết

Trong chương này chúng ta không chỉ thảo luận về Terraform là gì và nó so sánh với các công cụ IaC khác như thế nào, mà còn thực hiện bài thực hành triển khai thực tế. Đầu tiên là bài nhập môn "Hello World!" và thứ hai là sử dụng data source để thể hiện được khả năng dynamic của Terraform. Trong một số chương tiếp theo, chúng ta sẽ tìm hiểu các nguyên tắc cơ bản về cách hoạt động của Terraform cũng như các cấu trúc và thành phần cú pháp chính của ngôn ngữ Terraform HCL.

**Summary**

- Terraform là một Declarative IaC provisioning tool. Nó có thể deploy resource lên bất kỳ nền tảng public hoặc private cloud nào.
- provisioning tool, easy to use, free, declarative, cloud-agnostic, extensible
- Các thành phần chính của Terraform là resources, data sources, và providers
- Để deploy một Terraform project, trước hết bạn phải viết configuration code, sau đó cấu hình providers và các input variable, khởi tạo Terraform, và cuối cùng là apply các thay đổi. Dọn dẹp tài nguyên bằng `terraform destroy` command


  