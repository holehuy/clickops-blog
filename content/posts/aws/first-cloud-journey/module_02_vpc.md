---
title: "AWS Virtual Private Cloud - VPC"
date: 2024-07-07T06:00:20+06:00
hero: /images/posts/aws/module-2-vpc.png
description: "AWS Virtual Private Cloud - VPC"
menu:
  sidebar:
    name: "Module 02 - VPC"
    identifier: vpc-overview
    parent: first-cloud-journey
    weight: 2
---

Đây là một trong những bài viết đầu tiên của mình trong chương trình First Cloud Journey của AWS Study Group. Trong bài viết này mình sẽ tìm hiểu về các thành phần của AWS Virtual Private Cloud và làm một số lab liên quan đến các kiến thức này.

VPC là một dịch vụ cung cấp môi trường mạng riêng ảo, được cô lập với các mạng khác trên AWS Cloud. VPC cho phép khởi tạo các tài nguyên của AWS (như máy chủ, cơ sở dữ liệu, thiết bị cân bằng tải) trong một môi trường mạng riêng ảo và chúng ta có quyền kiểm soát. 

Trong hình bên dưới thể hiện các thành phần và các mối quan hệ cơ bản khi làm việc với VPC.

{{<img src="/assets/images/posts/first-cloud-journey/vpc-overview/vpc-overview.png" align="center" title="Tổng quan về VPC" >}}

## Tìm hiểu về CIDR và IPv4

CIDR (Classless Inter-Domain Routing) là một phương pháp cấp phát và định tuyến địa chỉ IP nhằm giải quyết những hạn chế của mô hình phân lớp địa chỉ IP IPv4 truyền thống (dựa trên các lớp A, B và C).

### Sự ra đời của CIDR

Trước khi CIDR ra đời, mô hình phân lớp địa chỉ IP IPv4 truyền thống (Class A, B, C) đã bộc lộ nhiều hạn chế như:

- Lãng phí không gian địa chỉ IP do phân lớp cố định
- Khó khăn trong việc quản lý và cấp phát địa chỉ IP
- Tăng nhanh số lượng bảng định tuyến do sự gia tăng mạnh mẽ của các mạng máy tính, dẫn đến làm cạn kiệt tính khả dụng của IPv4 nhanh hơn mức cần thiết

Để khắc phục các vấn đề trên, CIDR ra đời vào những năm 1990 như một giải pháp mới cho việc định tuyến và cấp phát địa chỉ IP. CIDR loại bỏ việc phân chia địa chỉ IP theo lớp cứng định như trước đây. Thay vào đó, CIDR sử dụng ký hiệu CIDR (**x.x.x.x/y**) để biểu diễn một khối địa chỉ IP, bao gồm 2 thành phần:

- Base IP: đại diện cho địa chỉ IP có trong mạng (x.x.x.x). Ví dụ (10.0.0.0, 192.168.0.0, ...)
- Subnet Mask: chỉ định số bit có thể thay đổi trên địa chỉ IP đó. Ví dụ (/0, /24, /32)

Nhờ CIDR, việc cấp phát và quản lý địa chỉ IP đã trở nên linh hoạt và hiệu quả hơn. Giúp tiết kiệm không gian IP, tối ưu hoá các bảng định tuyến và tăng cường khả năng tái sử dụng IP. 

Khi làm việc với AWS, CIDR thường được sử dụng trong **Security Group** rules và trong các hoạt động với networking. CIRD giúp chúng ta định nghĩa một hoặc dải địa chỉ IP, ví dụ:

- Muốn định nghĩa 1 địa chỉ IP: x.x.x.x/32
- Tất cả các địa chỉ IP: 0.0.0.0/0
- Hoặc một dải từ 192.168.0.0 đến 192.168.0.63: 192.168.0.0/26 (có 64 địa chỉ IP)

Chúng ta có thể dùng công cụ sau để tính một cách thuận tiện. Công cụ [CIDR Caculator](https://www.ipaddressguide.com/cidr) rất tiện nếu cần xác định dải IP mà CIDR cụ thể đang biểu diễn. Chỉ cần nhập địa chỉ CIDR vào công cụ và nhấp vào nút **Calculate**. Thao tác này sẽ trả về thông tin như First IP (IP đầu tiên), Last IP (IP cuối cùng), Number of Hosts (số lượng host), v.v...

{{<img src="/assets/images/posts/first-cloud-journey/vpc-overview/cidr-caculator.png" align="center" title="CIDR Caculator">}}

## VPC

Amazon Virtual Private Cloud (Amazon VPC) là dịch vụ cho phép khởi chạy các tài nguyên AWS trong mạng ảo cô lập theo logic xác định. Có toàn quyền kiểm soát môi trường mạng ảo của mình, bao gồm lựa chọn dải địa chỉ IP, tạo các mạng con, cấu hình các bảng định tuyến và cổng kết nối mạng. Chúng ta có thể dùng cả IPv4 lẫn IPv6 cho hầu hết các tài nguyên trong VPC. Mỗi VPC là một môi trường mạng ảo biệt lập trên AWS Cloud, và nó tài nguyên riêng của tài khoảng AWS. Các tài nguyên và các dịch vụ AWS khác sẽ hoạt động bên trong mạng VPC để cung cấp dịch vụ. Gần như chúng ta có thể mapping VPC với các mô hình mạng truyền thống, tuy nhiên những thành phần như routers, switches, VLANS không rõ ràng trong VPC, các thành phần này đã được trừu tượng hoá thành các thành phần ảo trong VPC.

VPC nằm trong 1 Region, khi tạo VPC cần xác định CIDR IPv4 bắt buộc và IPv6 (tuỳ chọn). Có thể có nhiều VPC trong 1 Region nhưng hạn chế hiện tại là chỉ có thể có tối đa 5 VPC trong 1 Region (tuy nhiên đây là soft limit, có thể xin điều chỉnh được). Mục đích chính của VPC thường dùng để phân tách các môi trường (PROD, DEV, TEST, STAGING) và cô lập.

Sử dụng VPC, chúng ta có thể xây dựng các infrastructure và đặt các instances bên trong đó, cấu hình tất cả những gì mà các tài nguyên bên trong VPC cần để hoạt động. Ví dụ
- IP addresses
- Subnets
- Routing
- Security
- Networking functionality (các chứng năng liên quan đến kết nối mạng)

Một VPC được tạo ra sẽ chỉ tồn tại trên một AWS Region. Mặc định khi tạo tài khoản AWS, Amazon đã tạo 1 VPC default với sẵn các Subnet mặc định, route tables, security groups, network access control list.

### Quản lý VPC

Việc quản lý các VPC sẽ được thực hiện thông qua các giao diện quản lý AWS sau:

- **AWS Management Console** Là một giao diện web cho phép quản lý tất cả các AWS resources (hình ảnh bên dưới)
- [AWS Command Line Interface (CLI)](https://aws.amazon.com/cli/)
- [AWS Software Development Kit (SDK)](https://aws.amazon.com/developer/tools/#SDKs)
- **Query APIs** Là các Low-level API gửi thông qua HTTP/HTTPS (tham khảo thêm tại [đây](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/Welcome.html))

{{<img src="/assets/images/posts/first-cloud-journey/vpc-overview/vpc-console-management.png" align="center" title="AWS VPC Console Management">}}

### IPv4 và IPv6 address blocks

Như đã tìm hiểu ở trên, dải địa chỉ IP VPC được xác định bằng IPv4 CIRD block và IPv6 CIDR block. Lúc tạo VPC chúng ta bắt buộc phải xác định primary CIDR block của mình, ngoài ra có thể add thêm các secondary CIDR block khác.

AWS recommends chúng ta nên chỉ định các khối CIDR từ **private address range** được quy định trong RFC 1918 (có thể xem bảng bên dưới). 

| RFC 1918 Private IP Range |
| :-------------------------: |
| 10.0.0.0 - 10.255.255.255 |
| 172.16.0.0 - 172.31.255.255 |
| 192.168.0.0 - 192.168.255.255 |

### Subnet

Đối với địa chỉ IP, CIDR block của mỗi Subnet (mạng con) là tập hợp con của CIDR block của VPC. Mỗi mạng con cô lập với các mạng con khác trong VPC. Một Subnet chỉ có 1 CIDR block, khi tạo cần xác định rõ để rành over-allocate IP cho subnet gây lãng phí.

Chúng ta có thể xây dựng các Subnet khác nhau cho các workload khác nhau như: các server instance sẽ chạy trong 1 subnet, các ứng dụng web sẽ chạy trong một subnet khác, ...

Subnet sẽ nằm trong hoàn toàn trong 1 Availability Zone và không thể kéo dài tới các AZ khác. Các Availability Zone là các vị trí riêng biệt được AWS thiết kế để cách ly để tránh bị ảnh hưởng khi các zone khác gặp vấn đề.

Có thể chia thành 2 loại Subnet:

- **Public Subnet** là một subnet được định tuyến tới một Internet Gateway, các tài nguyên trong Public Subnet có thể giao tiếp với internet thông qua IPv4 (Public IPv4 hoặc Elastic IP address)
- **Private Subnet** là một subnet không được định tuyến tới một Internet Gateway, do vậy chúng ta không thể truy cập đến các tài nguyên trong Private Subnet thông qua internet.

### Định tuyến Subnet - Route Table

Mỗi Subnet phải được liên kết với một bảng định tuyến, trong đó xác định các bộ quy tắc (rules / routes) xác định cách thức điều hướng các gói tin giữa các subnet trong VPC. Mỗi subnet được tạo tự động liên kết với bảng định tuyến chính của VPC (main route table). Bạn có thể tạo và liên kết với route table mới hoặc bạn có thể thay đổi nội dung của main route table.

### Kết nối Internet - Internet connectivity

**Internet Gateway (IGW)**: cho phép các tài nguyên trong VPC được kết nối với Internet. Để kết nối VPC với Internet, bạn cần tạo ra một IGW và liên kết nó với VPC.

**Network Address Translation (NAT):** để kết nối với internet thì thiết bị cần có Public IP address, tuy nhiên các thiết bị trong mạng private thì không có. NAT sẽ dịch địa chỉ Private IP sang Public IP để kết nối tới Internet nhưng vẫn đảm bảo tính bảo mật cho thiết bị ở mạng private.

**NAT Gateway:** là một thành phần cho phép server ảo trong mạng private có thể kết nối tới Internet hoặc dịch vụ khác của AWS nhưng lại ngăn không cho Internet kết nối đến server đó.

Ngoài ra còn có **NAT Instance** là một instance chúng ta tạo ra và có chức năng tương tự như NAT Gateway. Bạn có thể tham khảo sự khác nhau giữa NAT Gateway và NAT Instance được mô tả chi tiết [tại đây](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-comparison.html).

**Elastic IP** là một địa chỉ public IP có thể được liên kết với một instance trong VPC của bạn. Nó cho phép bạn giữ địa chỉ IP của máy chủ ảo không đổi khi khởi động lại instance.

### Network/subnet security

Network/subnet security đ ảm bảo rằng chỉ có những người dùng được phép truy cập vào các tài nguyên đám mây của bạn trong VPC. Bạn có thể cấu hình bảo mật cho VPC của mình bằng cách sử dụng **Security Group** và **Network Access Control List (NACL)**.

**Security Groups** hoạt động như một tường lửa ảo, cung cấp bảo vệ ở cấp độ instance. Chúng quản lý trạng thái của các kết nối (**stateful**), nghĩa là trạng thái của một kết nối sẽ được duy trì. Các security group sẽ quyết định các loại traffic (TCP, UDP, ICMP, v.v.) được phép truy cập vào các instance trong VPC.

**Network Access Control List (NACL)** hoạt động và cung cấp bảo vệ ở cấp độ subnet. Chúng là những firewall **stateless**, nghĩa là trạng thái của các kết nối không được duy trì. NACLs kiểm soát lưu lượng vào và ra khỏi các subnet trong VPC.

Ngoài ra còn cố một số dịch vụ khác liên quan đến VPC sẽ tìm hiểu sau:

- Virtual Private Network (VPN)
- Kết nối trực tiếp giữa các VPC với nhau (VPC Peering)
- Transit Gateway
- ....

## VPC Peering 

Khi làm việc, chúng ta có nhiều VPC được tạo ra và chúng có thể nằm trên các Region khác nhau, các account khác nhau. Và ý tưởng của VPC Peering là kết nối 2 VPC sử dụng AWS network. Khi 2 VPC được kết nối với nhau bằng cách sử dụng VPC peering, những dịch vụ trong các VPC đó có thể giao tiếp bằng IP riêng từ VPC nguồn đến VPC đích và ngược lại. 

Khi tạo kết nối peering, CIDR block của các VPC phải không được chồng chéo với nhau (overlapping CIDR), nếu overlap IP thì các instance sẽ không giao tiếp với nhau được. 

VPC Peering chỉ kết nối 2 VPC lại với nhau và chúng KHÔNG có tính chất bắt cầu. Tức là mặc dù VPC A kết nối với B, B kết nối với C, nhưng A và C không thể giao tiếp với nhau được, cần tạo thêm 1 kết nối để đấu nối giữa A và C nữa.

{{< alert type="info" >}}
Chúng ta có công thức tính số lượng kết nối VPC Peering khi có số lượng VPC (n) là n*(n-1)/2. Giả sử chúng ta có 5 VPC thì số lượng VPC Peering connection cần có để kết nối tất cả các VPC với nhau là: 5*(5-1)/2 = 10 kết nối.
{{< /alert >}}

Sau khi tạo VPC Peering connection, chúng ta phải update Route Table của các VPC subnet để các instance có thể giao tiếp với nhau.

{{< alert type="success" >}}
Chúng ta có thể tham chiếu và sử dụng các security của các account khác trong cùng một region nếu 2 VPC đã được đấu nối với nhau.
{{< /alert >}}

{{<img src="/assets/images/posts/first-cloud-journey/vpc-overview/reference-security-group-cross-acc-same-region.png" align="center" title="CIDR Caculator">}}

## VPC Endpoint

Khi làm việc với các dịch vụ của AWS, chẳng hạn như là DynamoDB, S3, ... các dịch vụ này hoàn toàn có thể truy cập từ internet. Tuy nhiên với các tài nguyên bên trong VPC, ví dụ như bên trong Private subnet thì traffic cần đi qua NAT Gateway rồi đi ra ngoài internet thông qua Internet Gateway rồi mới có thể connect đến DynamoDB. Hoặc với tài nguyên ở Public Subnet thì sẽ đi ra ngoài thông qua Internet Gateway. 

Như hình ở bên dưới là mô tả cho các traffic kể trên

{{<img src="/assets/images/posts/first-cloud-journey/vpc-overview/vpc-endpoint-diagram.png" align="center" title="Access AWS service from VPC">}}

Tuy nhiên trong một số trường hợp chúng ta cần truy cập các dịch vụ AWS mà không cần thông qua internet, truy cập chúng một cách riêng tư. VPC Endpoint sẽ là hướng giải quyết. VPC Enpoint cho phép kết nối tới các AWS resource mà không cần thông qua internet.

{{<img src="/assets/images/posts/first-cloud-journey/vpc-overview/vpc-endpoint-flow.png" align="center" title="Access AWS service from VPC flow">}}

Với option 1, traffic đi ra internet thông qua NAT Gateway và Internet Gateway để connect tới dịch vụ AWS. Option này vẫn hoạt động tốt, tuy nhiên về mặc chi phí ta phải bỏ ra nhiều tiền cho option này (phần lớn là ở NAT Gatewat). Và performance cũng sẽ không được tối ưu.

Với option 2 sử dụng VPC Endpoint cho phép connect các dịch vụ AWS sử dụng mạng private (private network) của aws thay vì sử dụng internet. Khi sử dụng VPC enpoints sẽ giúp tăng tốc độ đường truyền, đồng thời giảm độ trễ (vì không cần phải đi ra ngoài internet). 

Như vậy, khi sử dụng VPC endpoint đã dần loại bỏ Internet Gateway, NAT Gateway, ... mặc dù vẫn có thể truy cập dịch vụ AWS, điều này làm đơn giản hoá hạ tầng mạng của dự án. 

Có các loại VPC Endpoint sau:

- Interface Endpoint: 
  - cung cấp 1 ENI với private IP
  - đóng vai trò là điểm truy cập vào hầu hết các dịch vụ AWS
  - Cần attach một Security Group
  - Tính tiền theo giờ và số GB được xử lý

{{<img src="/assets/images/posts/first-cloud-journey/vpc-overview/vpc-interface-endpoint.png" align="center" title="Access AWS service from VPC flow">}}

- Gateway Enpoint: 
  - Cung cấp 1 gateway dùng như một Target trong Route Table
  - Hiện tại chỉ hỗ trợ cho 2 dịch vụ đó là S3 và DynamoDB
  - Miễn phí

Như hình trên, ta đã cung cấp một VPC Endpoint với type là Gateway endpoint để các instance trong private Subnet có thể truy cập được đến DynamoDB và S3. 

Đối với DynamoDB và S3, có 2 cách để truy cập thông qua Interface Endpoint hoặc Gatewate Endpoint. Vậy chọn cái nào cho phù hợp? Theo mình tất nhiên là chọn cái nào rẻ rồi =)))

Tuy nhiên cũng có vài trường hợp cần sử dụng Interface endpoint với S3 và DynamoDB. Vd: truy cập DynamoDB hoặc S3 khi dùng Site-to-Side VPN hoặc Direct Connect. 

## VPC Flow Logs

VPC FLow Logs là tính năng giúp capture thông tin IP traffic đến và đi Network Interfaces trong VPC (ngoài ra còn có thể capture các thông tin kết nối của các AWS managed interface như: ELB, RDS, RedisCache,...). Có 3 loại Flow Logs:
- VPC Flow Logs
- Subnet Flow Logs
- Elastic Network Interface (ENI) FLow Logs

Flow Logs sẽ hữu dụng khi chúng ta cần monitor hoặc troubleshoot khi có vấn đề về kết nối.

Dữ liệu Flow Logs có thể ghi vào S3, hoặc CloudWatch Logs hoặc Kinesis Data Firehose. 

upcoming ...








