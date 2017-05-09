require File.expand_path('../../libraries/barbican_utils.rb', __FILE__)


secrets = get_secrets_wo()
user_list = Array.new
user_list.push("octavia")

secrets.each do |secret|
  Chef::Log.info "Adding #{secret[:secret_name]} ..."
  Chef::Log.info("#{secret[:secret_name]}")
  add_secret(secret[:secret_name], secret[:content], "text/plain","aes", "cbc", 256)
  replace_acl(secret[:secret_name],user_list, "secret")
end
