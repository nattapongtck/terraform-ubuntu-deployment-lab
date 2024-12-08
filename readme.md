THIS TERRAFORM CODE IS FOR DEPLOY 3 VM ONLY, NO OTHERS CONFIGURATION INCLUDED
WORKS ONLY FOR PROXMOX!!!


PRIVATE KEY WILL CHANGE EVERYTIME YOU DESTROY THE VM, SO IT WILL NOT USEABLE ON YOU SIDE

AFTER APPLY TERRAFORM, USE THIS COMMAND TO VIEW THE PRIVATE KEY
terraform state show tls_private_key.ubuntu_vm_key

***Don't forget to change the local variables that will assign the IP of each node(VM) that will bridge to the default management interface
