from diagrams import Cluster, Diagram
from diagrams.onprem.container import Docker
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.inmemory import Redis
from diagrams.aws.network import ElbApplicationLoadBalancer
from diagrams.generic.device import Tablet
from diagrams.aws.compute import EC2ContainerRegistry
from diagrams.aws.storage import ElasticFileSystemEFSFileSystem
from diagrams.aws.security import IAM
from diagrams.aws.management import Cloudtrail, Cloudwatch

with (Diagram("rails-bank-trx-vpc-aws", show=True)):
    User = Tablet("User's laptop")

    with Cluster("AWS VPC"):
        with Cluster("AWS Resources"):
            ApplicationLoadBalancer = ElbApplicationLoadBalancer("ALB")
            EC2ContainerRegistry = EC2ContainerRegistry("ECR")
            IAM = IAM("IAM")
            # Cloudtrail = Cloudtrail("Cloudtrail")
            # Cloudwatch = Cloudwatch("Cloudwatch")

        with Cluster("ECS Cluster"):

            with Cluster("Public Subnet"):
                with Cluster("Frontend"):
                    react_frontend = Docker("React frontend")

            with Cluster("Private Subnet"):
                efs = ElasticFileSystemEFSFileSystem("EFS")

                with Cluster("Backend Services"):
                    rails_backend = Docker("Rails backend")
                    sidekiq_queue = Docker("Sidekiq queue")
                    redis_in_memory = Redis("Redis in Memory DB")
                    svc_group = [rails_backend, sidekiq_queue, redis_in_memory]

                with Cluster("Database"):
                    postgres_db = PostgreSQL("Postgres DB")

                    adminer = Docker("Adminer")

        User >> ApplicationLoadBalancer
        ApplicationLoadBalancer >> react_frontend
        react_frontend >> rails_backend
        rails_backend >> sidekiq_queue
        sidekiq_queue >> redis_in_memory
        redis_in_memory >> postgres_db
        postgres_db >> efs
