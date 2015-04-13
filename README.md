Kurento Elixir
=============

This library aims to provide the following components.
- backend server which communicates with KMS([Kurento Media Server](https://www.kurento.org/))
- frontend server which handles requests from browsers and connect them to KMS via backend server
- monitor server which monitors/reports usage and resource of the above servers

KMS is a very nice option when trying to implement a WebRTC related service,
but the official clients are available only in Java or Node.js, which
didn't motivate me to start using it seriously. Furthermore, at current
state it doesn't provide any tools to use it on distributed environment,
for example, publishing some media simultaneously to bunch of KMSs and load balancing
bunch of subscribers to them. I pretty much felt that Elixir (or Erlang, of course)
is a best fit in this case, so started on this project.

I will note that this is purely a personal project, and have nothing to do with the kurento project.
