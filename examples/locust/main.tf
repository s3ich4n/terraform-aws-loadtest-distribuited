module "loadtest" {

    source = "../../"
    #source  = "marcosborges/loadtest-distribuited/aws"

    name = "nome-da-implantacao-locust"
    nodes_size = var.node_size
    executor = "locust"
    loadtest_dir_source = "../plan/"
    region = "ap-northeast-2"
    
    # SETUP INSTANCE SIZE
    leader_instance_type = "t2.medium"
    nodes_instance_type = "c5n.xlarge"

    # LEADER ENTRYPOINT
    loadtest_entrypoint = <<-EOT
        nohup locust \
            -f ${var.locust_plan_filename} \
            --web-port=8080 \
            --expect-workers=${var.node_size} \
            --master > locust-leader.out 2>&1 &
    EOT
    
    # NODES ENTRYPOINT
    node_custom_entrypoint = <<-EOT
        nohup locust \
            -f ${var.locust_plan_filename} \
            --worker \
            --master-host={LEADER_IP} > locust-worker.out 2>&1 &
    EOT

    subnet_id = data.aws_subnet.current.id
    locust_plan_filename = var.locust_plan_filename
    ssh_export_pem = false
}
