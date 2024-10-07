# FOMO
An application for events.

This repository was made as the main assignment for the [Advanced Rails Bootcamp from Codigo Facilito](https://codigofacilito.com/bootcamps/rails-avanzado).

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
The ruby version used is 3.2.2 and the rails version is 7.2.0.
##### 1. Check out the repository

```bash
git clone git@github.com:barbaraim/FOMO.git
```
##### 2. Run dependencies

```bash
bundle install
```


##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
rails db:create
rails db:setup
rails db:migrate
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
rails s
```

And now you can visit the site with the URL http://localhost:3000

## REST API

This application comes with a REST API for creating new users, login in and managing events. The documentation can be found [here](https://documenter.getpostman.com/view/11793590/2sAXxMgu1q).

## GraphQl 

This application also has a graphql API, for new users, login in and managing events.
This repository also has Graphiql for documentation.

## Deployment

A deployed version of this application can be found on https://fomo.onrender.com. Unfortunaly, it is using the free tier, so it takes some time to wake up and will die in November 2024.

### Post-Mortem

Because of time issues, not all features were implemented. Some features that were not implemented where:
- Authentication with email for users
- Timed notifications and email notifications
- Use of tags and categories for events
- Soft-delete of all entities
