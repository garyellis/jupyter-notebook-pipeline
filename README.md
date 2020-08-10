# jupyter-notebook-pipeline
Maintain a jupyter notebook server ec2 instance as IAC in a pipeline.

# creating  a notebook server instance in gitlab
1. create an ssh private key.
2. upload the public key contents to your gitlab user profile
3. fork or copy the jupyter notebook instance infrastructure project.
4. clone the new project locally.
5. update terraform variables.
5. commit and push.
6. browse to the repository gitlab pipeline
7. copy the `notebook_server url` terraform output and `ip_address` from the terraform outputs in the pipeline job



# using the notebook server
1. retrieve the notebook server url.
   - download the notebook login url from aws ssm using the command in the terraform module output or
   - shell into the notebook server and run `jupyter notebook list`
2. setup sftp configuration in vscode
   - install the sftp extension from the Vscode market - https://marketplace.visualstudio.com/items?itemName=liximomo.sftp
   - update notebook and sync 
