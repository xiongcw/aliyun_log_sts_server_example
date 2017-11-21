require 'sinatra'
require 'json'
require 'aliyun/sts'

CONFIG = File.expand_path('../', __FILE__) + '/config.json'

# A raw policy that defines the policy rules by raw json
class RawPolicy
  def initialize(content)
    @content = JSON.load(content)
  end

  def serialize
    @content.to_json
  end
end

get '/' do
  conf = JSON.load(File.read(CONFIG))
  sts = Aliyun::STS::Client.new(
    access_key_id: conf['AccessKeyID'],
    access_key_secret: conf['AccessKeySecret']
  )

  policy_file = conf['PolicyFile']
  if policy_file
    path = File.expand_path(policy_file)
    policy = RawPolicy.new(File.read(path)) if File.exist?(path)
  end

  begin #开始
    token = sts.assume_role(
    conf['RoleArn'], 'my-app', policy, conf['TokenExpireTime'])
    headers(
    {
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-METHOD' => 'GET'
    })

    body(
      {
        'StatusCode' => 200,
        'AccessKeyId' => token.access_key_id,
        'AccessKeySecret' => token.access_key_secret,
        'SecurityToken' => token.security_token,
        'Expiration' => token.expiration
      }.to_json)
  rescue Exception => e
    headers(
    {
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-METHOD' => 'GET'
    })

    body(
      {
        'StatusCode' => 500,
        'ErrorCode' => e.error_code,
        'ErrorMessage' => e.message
      }.to_json)
  end #结束
  
end
