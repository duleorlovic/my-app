# Rerun template command:
# rm -f db/development.sqlite3 && git clean . -f -e template.rb -e README.md && git checkout . && rails app:template LOCATION=./template.rb

#
# Add devise
#
gem 'devise'
run <<-BASH
bundle
rails generate devise:install
rails g devise User
rake db:migrate
BASH

route <<-RUBY
post 'login_as', controller: 'application'
RUBY

insert_into_file 'app/views/layouts/application.html.erb', <<-ERB, before: "    <%= yield %>"
    <% if current_user.present? %>
      Hi <%= current_user.email %>
      <%= button_to 'Log Out', destroy_user_session_path, method: :delete, 'data-turbo': false %>
    <% else %>
      <%= link_to 'Log in', new_user_session_path %>
      <% User.all.each do |user| %>
        <%= button_to user.email, login_as_path(user_id: user.id) %>
      <% end %>
    <% end %>
    <div class='alert'>
      <%= alert %>
    </div>
    <div class='notice'>
      <%= notice %>
    </div>
ERB

insert_into_file 'app/controllers/application_controller.rb', <<-ERB, before: 'end'
  before_action :authenticate_user!, except: :login_as

  def login_as
    return unless Rails.env.development?

    user = User.find params[:user_id]
    sign_in :user, user, byepass: true
    redirect_to after_sign_in_path_for(user)
  end
ERB

#
# Add landing page and models
#
run <<-BASH
rails g controller pages index
rails g scaffold post user:references title
rails db:migrate
BASH

route <<-RUBY
root to: 'pages#index'
RUBY

insert_into_file 'app/views/layouts/application.html.erb', <<-ERB, before: "    <%= yield %>"
    <%= link_to 'Root', root_path %>
    <%= link_to 'Posts', posts_path %>
ERB

insert_into_file 'app/controllers/pages_controller.rb', <<-ERB, after: "ApplicationController\n"
skip_before_action :authenticate_user!
ERB
#
# Fixtures
#
file 'db/seeds.rb', <<-RUBY, force: true
Rails.logger = Logger.new(STDOUT)
Rake::Task['db:fixtures:load'].invoke
RUBY

file 'test/fixtures/users.yml', <<-RUBY, force: true
DEFAULTS: &DEFAULTS
  encrypted_password: <%= User.new.send(:password_digest, 'password') %>

user:
  <<: *DEFAULTS
  email: user@example.com
RUBY

file 'test/fixtures/posts.yml', <<-RUBY, force: true
post:
  user: user
  title: My Title
RUBY

run 'rails db:seed'
