# jupyter-notebook-pipeline
Maintain a jupyter notebook server ec2 instance as IAC in a pipeline.

# Creating  a notebook server instance in gitlab
1. Create an ssh private key as needed
```bash
ssh-keygen
```
2. Upload the public key contents to your gitlab user profile
```bash
aws --region us-west-2 import-key-pair --key-name $USER --public-key-material $(cat ~/.ssh_id_rsa.pub)
```
3. Fork the jupyter notebook instance infrastructure project to a new project under your namespace.
4. In your forked jupyter notebook instance project, browse to settings -> General -> Advanced and remove the fork relationship.
5. Set the terraform remote state path in `terraform/live/terragrunt.hcl`.
```hcl
remote_state {
  backend = "s3"
  config = {
    bucket = "<bucket-name>
    key = "jupyter-notebook/terraform/<your-gitlab-username>/live/${path_relative_to_include()}/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
    dynamodb_table = "terraform-locks"
  }
}

```
6. Update the notebook instance inputs in `terraform/live/jupyter-notebook/terragrunt.hcl`.
```hcl
inputs = {
  name = "<my-username>-notebook"
  key_name = "<my-keypair-name>"
  subnet_id = "<data science vpc subnet id>"
  vpc_id = "<data science vpc id>"
  tags = {<key name> = "<value name>"}

  # proxy configuration
  http_proxy  = "http://<proxy-hostname>:3128"
  https_proxy = "http://<proxy-hostname>:3128"
  no_proxy    = "localhost,127.0.0.1,::1,169.254.169.254,169.254.170.2,<domain-name>"


  # iam permissions
  kms_cmk_arns     = [<list of kms key arns>]
  s3_read_buckets  = [<list of s3 bucket arns>]
  s3_write_buckets = [<list of s3 bucket arns>]
}
```
7. Commit the changes in the gitlab UI.
6. Browse to the repository gitlab pipeline. There are two jobs `.pre` and `deploy`. The deploy job will require manual execution upon successful completion of the `.pre` job.
7. Run the `deploy` job and wait for it to complete.
8. Copy the `notebook_server url` terraform output and `ip_address` from the `deploy` job log.



# Using the notebook server
1. retrieve the notebook server url.
   - using aws cli
```bash
aws --region us-west-2 ssm get-parameters --name /terraform-aws-jupyter-notebook/<your-notebook-instance-name>/login --with-decryption
```
   - over ssh
```bash
ssh ec2-user@<notebook-server-address> -C "jupyter notebook list"
```
2. login to the notebook server from a browser.

3. install vscode extensions as needed. See the following vscode extensions for reference.
* https://code.visualstudio.com/docs/python/jupyter-support
* https://marketplace.visualstudio.com/items?itemName=liximomo.sftp


# destroying a notebook server instance in gitlab
1. Trigger the pipeline from the gitlab project.
2. On successful `.pre` job completion, open the `deploy` job and set the `target` variable value to `terragrunt-destroy`. before executing the job.
