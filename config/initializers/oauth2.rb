# Silence warning about PSN returning both access_token and id_token
OAuth2.configure do |config|
  config.silence_extra_tokens_warning = true # default: false
end
