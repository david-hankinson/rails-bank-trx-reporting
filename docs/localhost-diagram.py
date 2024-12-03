from diagrams import Cluster, Diagram
from diagrams.onprem.container import Docker
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.inmemory import Redis
from diagrams.generic.device import Tablet

with Diagram("rails-bank-trx-reporting", show=True):
    User = Tablet("User's laptop")

    with Cluster("Localhost"):
    # Define the containers


        with Cluster("Frontend"):
            react_frontend = Docker("React frontend")

        with Cluster("Backend Services"):
            rails_backend = Docker("Rails backend")
            sidekiq_queue = Docker("Sidekiq queue")
            redis_in_memory = Redis("Redis in Memory DB")
            svc_group = [rails_backend, sidekiq_queue, redis_in_memory]

        with Cluster("Database"):
            postgres_db = PostgreSQL("Postgres DB")
            adminer = Docker("Adminer")

        User >> react_frontend
        react_frontend >> rails_backend
        rails_backend >> sidekiq_queue
        sidekiq_queue >> redis_in_memory
        redis_in_memory >> postgres_db
