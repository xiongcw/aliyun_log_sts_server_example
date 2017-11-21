# A simple app server using STS

App Server一般作为一个企业的应用服务器，它管理着日志服务的
AccessKeyId/AccessKeySecret，服务于众多的客户端。当客户端（移动端
/Web/Client等）需要访问日志服务时，它们向App Server请求一个临时的token，并
利用这个token访问日志服务。

App Server可以实现更复杂的策略，为不同的客户端提供不同权限的token，隔
离不同的客户端的存储路径等。

## Run

### Install dependencies

    bundle install

### Start server

    ruby server.rb

### Open in your browser

http://localhost:4567/
