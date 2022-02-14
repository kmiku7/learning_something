
## Environment
### Docker Image
[URL](https://github.com/jenkinsci/docker/blob/master/README.md)


## Problems
### Use docker agent
```text
WorkflowScript: 2: Invalid agent type "docker" specified. Must be one of [any, label, none] @ line 2, column 13.
```
> You have to install 2 plugins: Docker plugin and Docker Pipeline. Hope that helps.

### Can not `build` when mark `Built-In Node` into offline.
Change the value of `Number of executors` to ZERO to disable the built-in node.  
https://www.jenkins.io/doc/book/security/controller-isolation/  

### Install packages under the alpine release
```shell
apk update && apk upgrade && apk add --no-cache bash git openssh
```


### Git: Host key verification failed.
```text
Caused by: hudson.plugins.git.GitException: Command "git fetch --no-tags --force --progress -- $GIT_URL +refs/heads/*:refs/remotes/origin/*" returned status code 128:
stdout: 
stderr: Host key verification failed.
fatal: Could not read from remote repository.
```
Actually it works if configure private key properly in the Credentials menu. I do not know why it does not work before...
