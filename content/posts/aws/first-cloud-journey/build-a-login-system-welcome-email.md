---
title: "Xây dựng hệ thống đăng nhập xác thực bằng email với Lambda Trigger và Amplify"
date: 2024-08-12T06:00:20+06:00
hero: /images/posts/aws/hero-workshop1.png
description: "Xây dựng hệ thống đăng nhập xác thực bằng email với Lambda Trigger và Amplify"
menu:
  sidebar:
    name: "Workshop Login System with Amplify, Cognito, Lambda and SES"
    identifier: build-a-login-system-welcome-email-with-amplify-cognito-etc
    parent: first-cloud-journey
    weight: 3
---

## Giới thiệu

Tính năng đăng nhập và gửi email chào mừng khách hàng mới là một tính năng cơ bản của một ứng dụng web và di động ngày nay. Với AWS Amplify, Cognito, Lambda và SES, chúng ta có thể xây dựng tính năng này một cách nhanh chóng. 

Trong bài viết này, chúng ta sẽ sử dụng một **Lambda** Function gọi là **Post Confirmation Lambda Trigger** để gửi email chào mừng một người dùng đăng ký mới thông qua **SES** (Simple Email Service). Song song với đó là sử dùng Amplify, một bộ công cụ cho phép phát triển các web/app fullstack hiệu quả. Xác thực người dùng thông qua Cognito User Pool.

Dưới đây là mô hình kiến trúc của workshop này:

**Hình 1:** Đăng nhập và gửi email chào mừng bằng Lambda Trigger và SES
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/workshop-lambda-ses.png" align="center" title="Hệ thống đăng nhập và gửi email chào mừng bằng Lambda Trigger và SES" >}}
 
## Chuẩn bị 

### Khởi tạo dự án

Chúng ta sẽ tiến hành tạo một application mới bằng cách sử dụng `create-vue` command và cài đặt các thư viện cần thiết để cấu hình Amplify. Để tạo một Vue application, chúng ta tiến hành gõ lệnh sau trên terminal:

```
$ npm init vue@latest
```

**Hình 2:** Tạo Vue Application sử dụng `npm`
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/create-vue-application.png" align="center" title="Tạo Vue Application sử dụng npm" >}}

### Cài đặt các thư viện cần thiết

Thay đổi thư mục làm việc bằng **cd** command:

```
$ cd welcome-app
```

Cài đặt các thư viện của Amplify

```
$ npm i @aws-amplify/ui-vue aws-amplify
```
 
Cài đặt [Amplify CLI](https://github.com/aws-amplify/amplify-cli)
```
$ npm install -g @aws-amplify/cli
```

Chạy `amplify init` tại thư mục dự án để thiết lập Amplify và các backend. Command này sẽ tạo ra một thư mục `amplify` chứa các cấu hình cần thiết cho Amplify app của chúng ta.

```
$ amplify init
```

**Hình 3:** Khởi tạo các cấu hình Amplify
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/amplify-init.png" align="center" title="Cấu hình Amplify" >}}

Cuối cùng chúng ta sẽ add thêm `auth` là phần xác thực cho workshop này. Tạo ra một Cognito User Pool để có thể quản lý danh tính và xác thực. Các lựa chọn cần chọn được thể hiện ở Hình 4 với một số lưu ý như sau:

- Chọn `Manual configuration` cho câu hỏi về default authentication
- Chọn `Y` cho câu hỏi *Do you want to configure Lambda Triggers for Cognito?* sau đó chọn `Post Confirmation` và `Create your own module`

{{< alert type="info" >}}
Ngoài ra bạn có thể tìm hiểu thêm một số các lựa chọn khác cho phần auth.
{{< /alert >}}

```
$ amplify add auth
```

**Hình 4:** Add auth cho Amplify application
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/amplify-add-auth.png" align="center" title="Add Auth to Amplify settings" >}}

## Cấu hình SES

Để gửi email bằng SES, trước hết chúng ta cần tạo và verify 1 Identity. Mặc định SES sẽ được cấu hình ở chế độ Sanbox, ở chế độ này, các địa chỉ email mình muốn gửi tới đều phải xác minh trước, trước khi SES có thể gửi tới nó (Trong phạm vi workshop, chúng ta sẽ cấu hình 2 địa chỉ email. 1 email dùnh để gửi, và một email dùng để nhận). Trong thực tế, chúng ta cần request AWS để chuyển sang Production Mode, từ đó chúng ta mới có thể gửi email đến khách hàng một cách mong muốn. 

Navigate sang màn hình SES console và chọn Identity, sau đó chọn Create Identity. Nhập địa chỉ email của bạn và xác nhận Create Identity.

{{< alert type="info" >}}
Giữ các email này vì nó sẽ được dùng trong phần cấu hình Lambda nằm ở đằng sau
{{< /alert >}}

**Hình 5:** Tạo SES Identity
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/create-ses-identity.png" align="center" title="Tạo SES Identity" >}}


Sau khi tạo Identity thành công, bạn sẽ nhận được một email có link để verify Identity, click vào link để verify nó. (Kiểm tra trong Thư rác nếu không thấy ở các mục email đến).
Hãy verify 2 email để làm một email gửi và một email nhận. Lúc này SES đã có thể gửi email đến các địa chỉ email này. 

## Cấu hình Lambda với SES

Di chuyển vào thư mục code của Lambda và dùng `pnpm` cài đặt thư viện aws-sdk
```
$ cd amplify/backend/function/<function-name>/src/custom.js
$ pnpm install aws-sdk
```

Source Code của Lambda Function chúng ta vừa tạo ở trên được đặt tại đường dẫn `amplify/backend/function/<function-name>/src/custom.js`

**Hình 6:** Đường dẫn của source Lambda Function trong project
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/function-directory.png" align="center" title="Lambda Function directory" >}}

Tới đây chúng ta sẽ tiến hành viết code để sử dụng Amazon SES, sửa file trên với nội dung bên dưới. Bạn có thể thay đổi nội dung `Subject` và `Body` theo ý của bạn.

```
const AWS = require("aws-sdk");
AWS.config.region = process.env.AWS_REGION;

const ses = new AWS.SES({ apiVersion: "2010-12-01" });
/**
 * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
 */
exports.handler = async (event, context) => {
  if (
    event.request.userAttributes.email &&
    event.triggerSource === "PostConfirmation_ConfirmSignUp"
  ) {
    return await sendEmail(
      event.request.userAttributes.email,
      "Congratulations " + event.userName + ", you have been confirmed: "
    );
  }
};

async function sendEmail(to, body) {
  var eParams = {
    Destination: {
      ToAddresses: [to],
    },
    Message: {
      Body: {
        Text: {
          Data: body,
        },
      },
      Subject: {
        Data: "Registration completed",
      },
    },

    // Thay đổi Source bằng email đã verify với SES ở bước trên
    Source: "firstcloudjourney@example.com",
  };
  return await ses.sendEmail(eParams).promise();
}
```

Đoạn code trên kiểm tra xem event nhận được event.triggerSource có phải là "PostConfirmation_ConfirmSignUp", để đảm bảo rằng chúng ta sẽ gửi email tới địa chỉ email của người dùng đã đăng ký. 
{{< alert type="warning" >}}
Chú ý, chúng ta cần phải thay đổi địa chỉ email của `Source` với email đã setup ở bước Cấu hình SES.
{{< /alert >}}

{{< alert type="info" >}}
Ở function handler trên, bạn hoàn toàn có thể thêm nhiều tính năng khác cho phù hợp với business của dự án. Chẳng hạn như là lưu thông tin email và thông tin người dùng vào DynamoDB, hoặc MySQL, ... Gửi các email marketing đến người dùng
{{< /alert >}}


Mặc định, Lambda không có quyền truy cập để sử dụng SES. Để Lambda Function có thể truy cập và sử dụng SES, cần thêm các các rule vào file `amplify/backend/function/<function-name>/custom-policies.json`. Việc này khi deploy sẽ tương đương với việc chúng ta tạo và cập nhật các IAM rule trên màn hình AWS console. Với phần code bên dưới, chúng ta cho phép Lambda Function có thể SendEmail và SendRawEmail đến tất cả resource.

```
[
  {
    "Action": ["ses:SendEmail", "ses:SendRawEmail"],
    "Resource": ["*"]
  }
]
```

Sau khi hoàn tất các bước trên, chúng ta đã sẵn sàng để deploy Lambda Function này. Sử dụng `amplify push` để deploy các cấu hình trên

```
$ amplify push -y
```

**Hình 7:** Deploy amplify app
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/amplify-push.png" align="center" title="Deploy amplify app" >}}

## Cấu hình Vue Application
Cuối cùng, chúng ta cần cấu hình Vue app với Authentication. 

Chỉnh sửa file `index.html` trong thư mục dự án để thêm thẻ script ngay trước thẻ đóng body như bên dưới.
```
...
    <script>
      window.global = window;
      window.process = {
        env: { DEBUG: undefined },
      };
      var exports = {};
    </script>
  </body>
```

Trong file `vite.config`, add thêm `runtimeConfig`
```
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
      "./runtimeConfig": "./runtimeConfig.browser",
    },
  },
});
```

Chỉnh sửa file `src/main.ts`, chúng ta cần import module Amplify và aws-export và configure
```
import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'

import { Amplify } from "aws-amplify";
import aws_exports from "./aws-exports";
Amplify.configure(aws_exports);

createApp(App).mount('#app')
```

Di chuyển đến file `App.vue` và thêm Authenticator. Thành phần này sẽ thêm màn hình đăng nhập, đăng ký, tất cả cấu hình đã được định sẵn để chúng ta sử dụng.
```
<script setup lang="ts">
import { Authenticator } from "@aws-amplify/ui-vue";
import "@aws-amplify/ui-vue/styles.css";
</script>

<template>
  <Authenticator>
    <template v-slot="{ user, signOut }">
      <h1>Hello {{ user.username }}!</h1>
      <button @click="signOut">Sign Out</button>
    </template>
  </Authenticator>
</template>
```

**Hình 8:** Chỉnh sửa App.vue
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/edit-app-vue.png" align="center" title="Chỉnh sửa App.vue" >}}

## Testing

Run application bằng `npm run dev` command. Truy cập vào host (ở trường hợp này là http://localhost:5173). Chúng ta sẽ thấy màn hình Authenticator với 2 phần là **Sign In** và **Create Account**

**Hình 9:** Màn hình Tạo Account
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/create-account.png" align="center" title="Create account screen" >}}

Click vào Create Account và nhập email (địa chỉ email bạn đã tạo ở bước Cấu hình SES). Sau khi tạo account thành công, màn hình yêu cầu nhập mã OTP sẽ hiện ra và một email chứa mã OTP sẽ được gửi tới địa chỉ email vừa nhập. 

**Hình 10:** Màn hình Verify OTP
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/otp-screen.png" align="center" title="Verify account screen" >}}

**Hình 11:** Email chứa OTP được gửi về
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/otp-email.png" align="center" title="Verify email" >}}

Sau khi verify email và login thành công. Một email thông báo registration thành công sẽ được gửi tới email của bạn (với sender là phần chúng ta đã code ở bước Cấu hình Lambda với SES).

**Hình 12:** Email thông báo đăng ký thành công
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/success-email.png" align="center" title="Email registration success" >}}

## Clean Resource

Như vậy, với bài này, chúng ta đã tìm hiểu được cách một event trigger một lambda và implement lambda function xử lý một event như thế nào, cách cấu hình lambda function để truy cập và gửi email thông qua SES, ... Ngoài ra còn tìm hiểu cơ bản về dịch vụ Amazon Cognito,

Run `amplify delete` tại thư mục dự án và confirm delete resource. 
```
$ amplify delete
```

**Hình 12:** Clean Resource
{{<img src="/assets/images/posts/first-cloud-journey/workshop1/clean-resource.png" align="center" title="Clean Resource" >}}







