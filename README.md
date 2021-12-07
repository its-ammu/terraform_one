# Assignment 4
- [x] Create VPC
- [x] Create Subnets
- [x] Create route tables
- [x] Create IG
- [x] Create 2 instances 
- [x] Add userdata
- [ ] Create ALB with instances
- [ ] Create RDS instance
- [ ] Check connectivity

## Layout
- The `network.tf` file consistes of the network resources like VPC, Subnets, Route tables, IG
- The `main.tf` file will have the main part, i,e; Instances, ALB, RDS 
- `variables.tf` is used to declare variables and will add a `.tfvars` file if needed in future.
