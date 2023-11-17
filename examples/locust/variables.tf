variable "subnet_name" {
    default = "stress_test_subnet"
    description = "Subnet name"
}


variable "node_size" {
    description = "Size of total nodes"
    default = 5
}

variable "locust_plan_filename" {
    default = "locust/basic.py"
}
