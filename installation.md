# Install
* [erlang](https://www.erlang.org/)
* [elixir](http://elixir-lang.org/)
* [nodejs](https://nodejs.org/en/)
* [postgres](https://www.postgresql.org/)
* [pgAdmin](https://www.pgadmin.org/)

# Run
    mix local.hex

    mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

    npm install

    mix deps.get
	mix deps.compile
	
	mix ecto.create
    mix ecto.migrate
	
	mix test

	mix phoenix.server

	
# Additional
* May need to create migrations dir in priv/repo
* For npm install may need to run as admin. alternatively `npm install -g package.json@latest`
* May need to update passwords in config