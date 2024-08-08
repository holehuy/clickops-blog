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

Trong hình bên dưới thể hiện các thành phần và các mối quan hệ cơ bản khi chúng ta làm việc với VPC.

{{< img src="/assets/images/posts/first-cloud-journey/vpc-overview.png" align="center" title="Tổng quan về VPC" >}}

## Tìm hiểu về CIDR và IPv4

CIDR (Classless Inter-Domain Routing) là một phương pháp cấp phát và định tuyến địa chỉ IP nhằm giải quyết những hạn chế của mô hình phân lớp địa chỉ IP IPv4 truyền thống (dựa trên các lớp A, B và C).

### Sự ra đời của CIDR

Trước khi CIDR ra đời, mô hình phân lớp địa chỉ IP IPv4 truyền thống (Class A, B, C) đã bộc lộ nhiều hạn chế như:

- Lãng phí không gian địa chỉ IP do phân lớp cố định
- Khó khăn trong việc quản lý và cấp phát địa chỉ IP
- Tăng nhanh số lượng bảng định tuyến do sự gia tăng mạnh mẽ của các mạng máy tính, dẫn đến làm cạn kiệt tính khả dụng của IPv4 nhanh hơn mức cần thiết

Để khắc phục các vấn đề trên, CIDR ra đời vào những năm 1990 như một giải pháp mới cho việc định tuyến và cấp phát địa chỉ IP. CIDR loại bỏ việc phân chia địa chỉ IP theo lớp cứng định như trước đây. Thay vào đó, CIDR sử dụng ký hiệu CIDR (**x.x.x.x/y**) để biểu diễn một khối địa chỉ IP, bao gồm 2 thành phần:

- Base IP: đại diện cho địa chỉ IP có trong mạng (x.x.x.x). Ví dụ (10.0.0.0, 192.168.0.0, ...)
- Subnet Mark: chỉ định số bit có thể thay đổi trên địa chỉ IP đó. Ví dụ (/0, /24, /32)

Nhờ CIDR, việc cấp phát và quản lý địa chỉ IP đã trở nên linh hoạt và hiệu quả hơn. Giúp tiết kiệm không gian IP, tối ưu hoá các bảng định tuyến và tăng cường khả năng tái sử dụng IP. 

Khi làm việc với AWS, CIDR thường được sử dụng trong **Security Group** rules và trong các hoạt động với networking. CIRD giúp chúng ta định nghĩa một hoặc dải địa chỉ IP, ví dụ:

- Muốn định nghĩa 1 địa chỉ IP: x.x.x.x/32
- Tất cả các địa chỉ IP: 0.0.0.0/0
- Hoặc một dải từ 192.168.0.0 đến 192.168.0.63: 192.168.0.0/26 (có 64 địa chỉ IP)

Chúng ta có thể dùng công cụ sau để tính một cách thuận tiện. Công cụ [CIDR Caculator](https://www.ipaddressguide.com/cidr) rất tiện nếu chúng ta cần xác định dải IP mà CIDR cụ thể đang biểu diễn. Chỉ cần nhập địa chỉ CIDR vào công cụ và nhấp vào nút **Calculate**. Thao tác này sẽ trả về thông tin như First IP (IP đầu tiên), Last IP (IP cuối cùng), Number of Hosts (số lượng host), v.v...

{{<img src="/assets/images/posts/first-cloud-journey/vpc-overview/cidr-caculator.png" align="center" title="CIDR Caculator">}}

## VPC

Amazon Virtual Private Cloud (Amazon VPC) là dịch vụ cho phép chúng ta khởi chạy các tài nguyên AWS trong mạng ảo cô lập theo logic xác định. Có toàn quyền kiểm soát môi trường mạng ảo của mình, bao gồm lựa chọn dải địa chỉ IP, tạo các mạng con, cấu hình các bảng định tuyến và cổng kết nối mạng. Chúng ta có thể dùng cả IPv4 lẫn IPv6 cho hầu hết các tài nguyên trong VPC. Mỗi VPC là một môi trường mạng ảo biệt lập trên AWS Cloud, và nó tài nguyên riêng của tài khoảng AWS của chúng ta. Các tài nguyên và các dịch vụ AWS khác sẽ hoạt động bên trong mạng VPC để cung cấp dịch vụ. Gần như chúng ta có thể mapping VPC với các mô hình mạng truyền thống, tuy nhiên những thành phần như routers, switches, VLANS không rõ ràng trong VPC, các thành phần này đã được trừu tượng hoá thành các thành phần ảo trong VPC.

VPC nằm trong 1 Region, khi chúng ta tạo VPC cần xác định CIDR IPv4 bắt buộc và IPv6 (tuỳ chọn). Chúng ta có thể có nhiều VPC trong 1 Region nhưng hạn chế hiện tại là chỉ có thể có tối đa 5 VPC trong 1 Region (tuy nhiên đây là soft limit, có thể xin điều chỉnh được). Mục đích chính của VPC thường dùng để phân tách các môi trường (PROD, DEV, TEST, STAGING) và cô lập.

Sử dụng VPC, chúng ta có thể xây dựng các infrastructure và đặt các instances bên trong đó, cấu hình tất cả những gì mà các tài nguyên bên trong VPC cần để hoạt động. Ví dụ
- IP addresses
- Subnets
- Routing
- Security
- Networking functionality (các chứng năng liên quan đến kết nối mạng)

Một VPC được tạo ra sẽ chỉ tồn tại trên một AWS Region. Mặc định khi tạo tài khoản AWS, Amazon đã tạo 1 VPC default với sẵn các Subnet mặc định, route tables, security groups, network access control list.

### Quản lý VPC

Việc quản lý các VPC sẽ được thực hiện thông qua các giao diện quản lý AWS sau:

- **AWS Management Console** Là một giao diện web cho phép chúng ta quản lý tất cả các AWS resources (hình ảnh bên dưới)
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

Ngoài ra chúng ta còn có **NAT Instance** là một instance chúng ta tạo ra và có chức năng tương tự như NAT Gateway. Bạn có thể tham khảo sự khác nhau giữa NAT Gateway và NAT Instance được mô tả chi tiết [tại đây](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-comparison.html).

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

## Hands On Lab

Bài lab trong module này là [Start With Amazon VPC and AWS VPN Site-to-Site](https://awsstudygroup.com)

Mình sẽ chia bài lab này thành 2 phần:

1. Thực hành cơ bản về VPC để hiểu các thành phần của nó
2. Cấu hình VPN Site to Side để kết nối môi trường VPC của AWS

### Thực hành cơ bản về VPC

Trong link lab thì đã có đủ các hướng dẫn 








