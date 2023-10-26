## Terraform

Terraform is declarative, describing an intended goal rather than the steps needed to reach the goal - WHAT TO DO

Procedural tools specify step by step how to achieve the desired end state - HOW TO DO

Procedural approach ( Imperative )

    -	ec2:
     	count: 5
     	image: ami-0c02fb5595c7d316
     	instance_type: t2.micro

if we increase it to 15, it will give us 20 servers

Declarative approach does the same but by declarations

    -   resource "aws_instance" "server" {
            count = 5
            ami = "ami-0c02fb5595c7d316"
            instance_type = "t2.micro"
        }

if we increase it to 15, it will give us 15 servers
we only have to declare end state.

## AWS Basics VPC

- VPC ( Virtual Private Cloud )

- VPC closely resembles a traditional network in a data center and you'll launch the other resources in a VPC.

- Amazon VPC is a networking layer that AWS users use for connectivity.

## AWS Basics EC2

- Elastic Compute Cloud (EC2)

- It provides scaling and computing capacity in the AWS cloud.

- We use this to launch virtual servers, configure security and networking and manage storage.

## Variable Precedence

1. `-var` and `-var-file`
2. `terraform.tfvars`
3. env variable (`TF_VAR_*`)

## Route table

- Virtual router within your VPC

- A route table contains routes that determine where the network traffic is directed

## Internet gateway

- is a VPC component that allows communication between your VOC and internet
- It has two purposes,

  1. to route internet traffic
  2. and NAT

- It suports both `ipv4` and `ipv6`

- A subnet that is associated with a route table that has a route to a internet gateway is called public subnet and private subnet vice-versa

## Security groups and firewall config

- A network ACL operates at the subnet, first layer of defense, is like a firewall of VPC subnets

- A security group operates at the instance (VM) level, second layer of defense, is like a firewall of ec2 instances

- Security groups control how traffic is permitted into or out of the EC2 instances

- A security group supports only allow rules. All internet traffic to a security group is implicitly denied.

- Security groups are stateful which means any change applied to an incoming rule will be automatically applied to an outgoing rule too.

- If we allow incoming traffic to port 80, outgoing from 80 will be automatically allowed too.

- On the othe rhand Network ACL's support both Allow and Deny rules, and by default all traffic is allowed, it is also stateless

## SSH Public Key Authentication

- ### SSH Key Pair:

  public and private key used to authenticate to the EC2 instance

- The public key is stored on your instance and the private key on the client.

```bash
    ssh-keygen -t rsa -b 2048 -C 'test key' -N '' -f ~/.ssh/test_rsa
```

- By default ssh prompt the user for a passphrase that is used to encrypt the private key locally .
- `-N` provides the passphrase and if the string followed by it is empty, it wont encrypt the private key
  and `-f` specifies alternate location

## Output values

- are used to export strutured data about resources

- Output values are like function's return values.

- Root module can use outputs to print values at the terminal after running terraform apply

## Replace

```bash
terraform plan -replace="aws_instance.my_vm"
```

- to replace without going everything from beginning

- use `apply` when sure

## Running commands on EC2

1. ### `user_data`

   - we can run scripts or commands by giving them as value to an attribute called `user_data`

   - Passes the commands to the cloud provider which runs them on the instance

   - Idiomatic and native to the cloud provider

   - Viewable in AWS console (recommended way)

2. ### `cloud-init`

   - we can use this which is an industry standard for cloud instance initialisation

   - It runs on most Lonux distributions and cloud providers

   - `cloud-init` can run `per-instance` or `per-boot` configuration

3. ### `Packer`

   - Open-source devops tool made by HashiCorp to create images from a single json file

4. ### `Provisioners`

   - `user_data` is native to the cloud provider and `provisioners` are native to Terraform

## HCL

### Variables in Depth

- ### 1. Simple:

  number, string, bool, null

- ### 2. Complex:
  - Collection types: list, map, set (of same type)
  - Structural types: tuple, object (can have different types)

## COUNT

By default a terraform resource block configures one real infrastructure object.

- ### count

  is used to manage similar resources

- ### count and for_each
  are looping techniques

## Locals

Local values (locals) are named values that you can refer to in your configuration.

Compared to variables, locals do not change values during a Terraform run, and are not submitted by users but calculated inside the configuration.

Locals are available only in current module. They are locally scoped.

A Local is only accessible within the local module vs a Terraform variable which can be scoped globally.

Another thing to note is that a local in Terraform doesn't change its value once assigned. A variable value can be manipulated via expressions.

You can get locals inside console

```bash
terraform console
```

## Splat Expressions

```bash
output "private_addresses" {
  value = aws_instance.my_vm[*].private_ip
}
```

only applies to `List`, `Sets` and `Tuples` not to `Maps` and `Objects`

## State

- Terraform stores state information about your managed infrastructure.

- State is used by Terraform to map real-world resources to your configuration, keep track of metadata, and to improve performance.

- ### Backends and Remote State

  Local State is not good for production environments when working in a team, it should be shared with rest of team.

  Users should check if they have the latest terraform state before running terraform.

  `Concurrency` is another problem, nobody should add terraform at the same time, otherwise current state cant be changed and the state file can get corrupted.

  So, It needs a locking mechanism to avoid running into `race conditions`.

  `Solution`: store the state remotely using the correct backend.
  Backends define how operations are executed and where the Terraform State is stored.

  The default backend is local, we want remote state to share it.

  Terraform supports storing states on many backends such as,

  - AzureRM
  - COS
  - Kubernetes
  - Postgres
  - S3

    others...

- to switch back to local state, youc an comment backend.tf and then run

```bash
  terraform init -migrate-state
```

after the above command, the previous s3 or any backend will be migrated to local backend, after commenting the `backend.tf`. Terraform will now operate locally.

Try to run instance in two terminals now.
In `one` run

```bash
  terraform apply -auto-approve
```

and in `second`, run

```bash
  terraform destory -auto-approve
```

This is the error in `second`

```bash
   Error: Error acquiring the state lock
│
  │Error message: Failed to read state file: The state    file could not be read: read terraform.tfstate: The process cannot access the file because another process has
  │ locked a portion of the file.
  │
  │ Terraform acquires a state lock to protect the state from being written
  │ by multiple users at the same time. Please resolve the issue above and try
  │ again. For most commands, you can disable locking with the "-lock=false"
  │ flag, but this is not recommended.
```

so in local, `lock` is enabled by `default`

now `uncomment` the `backend.tf` file

and test the same:

after running

```bash
  terraform init -migrate-state
```

to migrate to remote state
It will show no error of lock.

Now enable it in aws console.

Search for `DynamoDB`

### DynamoDB:

is a NoSql database that supports consistent reads and conditional writes at any scale

1. Create a new table
2. Create a Partition key:
   It is part of table's oprimary key, it is called `LockID`

   now, `Create the Table`, setting everything else to `default` values

now set it up in `backend.tf`

and test the same:

after running

```bash
  terraform init -reconfigure
```

as the remote state was changed, it will save the current configuration to the same remote state.

Now check if locking works as expected

Yes it works with error

```bash
  Error: Error acquiring the state lock
```

## Now migrating the state to Terraform Cloud

Good alternative to Amazon S3, to keep your state file secure and share it with your team

If your configuration includes a `cloud` block , it cannot include a `backend` block
`workspace` is not required to exist, but if it does, there should be no state file in it.

The persistent data in `backend` belongs to a `workspace`
and by default Terraform starts witha single workspace named `default`. It cannot be deleted.

To see current workspace, run

```bash
  terraform workspace show
```

when we define a cloud block , we must authenticate to Terraform cloud to process with initialisation.

```bash
  terraform login
```

it will create a json in user's home directory

```path
  C:\Users\tramb\AppData\Roaming\terraform.d\credentials.tfrc.json
```

now run `init`

now we can save state file in the cloud

## Terraform Security

- Don't store secrets in plain text!
- Store Terraform State in a backend that supports encryption.

- we can use `aws_db_instance`, using `Mysql` engine

- we can also set password via terminal

  ```bash
    export TF_VAR_db_password="shahrukh12345"
  ```

  entire command was stored in bash history too(bad)
  just add `whitespace` before th command name, and it will not be saved in history

## AWS Secrets Manager

- Store secrets securely
- Go to `Secrets Manager` in aws console
