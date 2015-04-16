defmodule KC do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    objectStore = KC.Core.getObjectStoreName()
    kmsClient = KC.Core.getKmsClientName()
    eventHandler = KC.config(:event_handler)

    children = [
      # Define workers and child supervisors to be supervised
      worker(objectStore, [[name: objectStore]]),
      worker(eventHandler, [[name: eventHandler]]),
      worker(kmsClient, [
        {KC.config(:kms_conn_info), eventHandler},
        [name: kmsClient]
      ]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KC.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config(name) do
    Application.get_env(:KC, name)
  end
end
