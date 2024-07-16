---
title: "Bài 1 - Vault Architecture - Các component của Vault"
date: 2020-06-08T06:00:20+06:00
hero: /images/posts/vault-approaches/vault-components-hero-image.png
description: Tổng quan về Vault Components"
menu:
  sidebar:
    name: "1 - Vault Component"
    identifier: vault-components
    parent: vault-approaches
    weight: 10
---
## Architecture
Vault là một hệ thống phức tạp với nhiều thành phần riêng biệt. Bài này mình sẽ trình bày về các thành phần đó của vault, các phiên bản khác nhau cũng như lý do mà các tổ chức chọn Vault.

## Tổng quan
Sơ đồ bên dưới mình lấy từ docs chính thức của Vault, minh hoạ hệ thống "phức tạp" và các thành phần của nó.

![alt text](https://content.hashicorp.com/api/assets?product=vault&version=refs%2Fheads%2Frelease%2F1.17.x&asset=website%2Fpublic%2Fimg%2Flayers.png&width=1506&height=841)

Trong post này mình sẽ đi qua 4 thành phần cơ bản đó là:
- Storage Backends
- Secret Engines
- Authentication Methods
- Audit Devices

## Storage Backend
`Storage Backends` chính là nơi sẽ thực sự lưu trữ tất cả dữ liệu đã được mã hoá trên vault.
Có rất nhiều tuỳ chọn khác nhau cho `Storage Backends` bao gồm một số hệ thống lưu trữ khác nhau như Filesytem, Amazon S3, etcd, Consul ...
Vault không trực tiếp lưu trữ các secret. Thay vào đó nó sẽ lưu trữ các metadata của các secret và các định vị để truy cập các secret đó. Việc lựa chọn Storage Backend phụ thuộc vào các yêu cầu về tính sẵn sàng, tính bảo mật và khả năng mở rộng.

Storage Backends định vị vị trí để lưu trữ dữ liệu, được xác định trong Vault configuration file với các parameter thích hợp. Nếu chúng ta lưu trữ dùng console, thì file configuration có thể khác so với khi chúng ta sử dụng Raft hoặc DynamoDB... (vì mỗi loại có các thông số khác nhau). 
Tất cả các dữ liệu lưu trữ ở Storage Backends đều được mã hoá in transit bằng TLS certificates, và mã hoá at rest bằng AES256

## Secret Engines
Đây thực sự là trái tim của Vault, là thành phần dùng để lưu trữ (**store**), tạo (**generate**) và mã hoá dữ liệu (**encrypt** data). Nôm na nó là thành phần chịu trách nhiệm quản lý secret cho tổ chức của chúng ta.
Một số `Secret Engines` chỉ đơn giản là lưu trữ và đọc dữ liệu ví dự như là encrypted Redis/Memcached. Ngoài ra còn có các Secret Engines có thể kết nối đến các service khác để tạo generate dynamic credentials, hoặc encryption, totp generation, certificates, ...

## Authentication Methods
Để có thể truy cập và sử dụng `Secret Engines` chúng ta cần phải xác thực. Vault có Authentication Methods để làm điều đó. Authentication Methods cho phép các client xác thực với Vault bao gồm: username/password, Amazon Web Services, GitHub, Google Cloud Platform, Kubernetes, Microsoft Azure, Okta ...

## Audit Devices
Không chỉ có Vault mà mình nghĩ bất kì sản phẩm nào cũng cần theo dõi và kiểm soát các hoạt động trong hệ thống. Chúng ta cần đảm bảo rằng mọi thứ, mọi hoạt động diễn ra trong Vault phải dược audit 100%. `Audit Devices` ghi lại tất cả hoạt động với Vault bao gồm cả hoạt động xác thực và các hoạt động với các secret.

Các audit log được định dạng dưới dạng JSON nên có thể dễ dàng phân tính để tìm kiếm thông tin. Hầu hết các thông tin nhạy cảm sẽ được hashing sử dụng HMAC-SHA256. Mục đích của hàm băm là để các secret không ở dạng plaintext trong audit log của chúng ta.

## High-Level overview
Chúng ta quay lại với hình ảnh về Vault Architechture ở trên
![alt text](https://content.hashicorp.com/api/assets?product=vault&version=refs%2Fheads%2Frelease%2F1.17.x&asset=website%2Fpublic%2Fimg%2Flayers.png&width=1506&height=841)

Lớp mã hoá (`encryption layer`) của Vault được goi là `Barrier` chịu trách nhiệm mã hoá và giải mã dữ liệu vault. Khi máy chủ vault hoạt động, vault sẽ ghi dữ liệu vào `Storage Backend` của nó. Vì phần `Storage Backend` nằm bên ngoài `Barrier` nên nó được coi là không đáng tin cậy nên vault sẽ mã hoá dữ liệu trước khi gửi chúng đến `Storage Backend`. Cơ chế này đảm báo rằng nếu có kẻ tấn công cố gắng giành quyền truy cập vào `Storage Backend` thì dữ liệu sẽ không thể bị xâm phạm vì nó vẫn được mã hoá cho tới khi vault giải mã được dữ liệu. Phần Storage Backend sẽ là layer cung cấp dữ liệu một cách bền bỉ, nơi dữ liệu được bảo mật và khả dụng khi máy chủ khởi động lại.

Khi máy chủ vault được khởi động, nó sẽ bắt đầu ở trạng thái `sealed` *(niêm phong)*. Trước khi có thể thực hiện bất kì thao tác nào trên Vault, nó phải được huỷ niêm phong và ở trạng thái `unsealed`. Điều này được thực hiện bằng cách cung cấp các `unseal keys`. Trong quá trình initialization của Vault, nó sẽ tạo ra một khoá mã hoá được sử dụng để bảo vệ tất cả dữ liệu của Vault. Khoá này được bảo vệ bởi root key được lưu trữ cùng với các dữ liệu Vault khác nhưng được mã hoá bằng một cơ chế khác gọi là `unseal keys`.
