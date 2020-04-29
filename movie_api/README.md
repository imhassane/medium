# Movie Api with Plug, Cowboy & MongoDB

**Building an api from scratch without using phoenix or any other framework**

## TODO
- [x] Connection to mongo db
- [x] Implement the crud in the repository
- [x] Implement the crud in the services
- [x] Adding the routes

### How does it work.
When we run the application, the supervisor will start its children and
cowboy will start the server, mongodb will connect to the database.<br />

As we've given the mongo's process the `:database` name, we will be able
to call it everywhere in our application without sharing it process id.<br />

The repository will be in charge of the communication with the database, it'll
receive a request and will send a response without any modification.<br />

The service will receive the client's request and will make the verifications
needed and will convert all the data if necessary. Here we will parse the
responses to json with `Jason`.<br />

The endpoint module wil listen to the client's request and will pass to them
to the service which will return a response with the following pattern: `{:code, :message}`. <br/>
The `:code` will be either `:ok`, `:not_found`, `:malformed_data` or `:server_error`.
<br/>
Each code is respectively associated with an HTTP code: `200`, `404`, `400`, `500`. <br />

This is a very basic api with no security, the goal was to show how to use `Plug`,
`Cowboy` and `MongoDB` to build something from scratch.
<hr />
Thank you