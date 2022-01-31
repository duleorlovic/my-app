# MyApp

This is sample app for demo on TRK.

For quick preview you can use docker:

```
git clone git@trk.com:duleorlovic/my-app.git
cd my-app
docker up
```

To create from ground up, you can follow this steps.
First add devise gem, create user model (using devise generator), landing page
and posts scaffold. We will use this template
https://github.com/duleorlovic/my-app/blob/main/template.rb

```
rails new my-app -m https://raw.githubusercontent.com/duleorlovic/my-app/main/template.rb
cd my-app
```

When you run the server you can play with the app
```
rails s
firefox http://localhost:3000
```
