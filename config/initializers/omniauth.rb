# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :google_oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
#   scope: ['email',
#     'https://www.googleapis.com/auth/gmail.modify'],
#     access_type: 'offline'}
# end
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :google_oauth2, '340385820887-h1kg6r30rlp7svv0iqc66tl67dklggo0.apps.googleusercontent.com', '2k4EqcYCg_5aXwPwgHo23TVB', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
  #provider :identity
end