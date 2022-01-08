# terraform by Mounir Challouk
This IaS (Infrastructure as Code) will create the following:
<ul>
    <li>Will host a PHP application on 3 EC2 instances behind a load balancer
      <ul>
        <li>2 in subnet1 (10.0.1.0/24)</li>
	<li>1 in subnet2 (10.0.2.0/24)</li>
      </ul>
    </li>
    <li>The PHP application will invoke a lambda function, which replies with the EC2 instance IP address and will show an image stored on an S3 bucket.
    </li>  
  </ul>


To use this Terraform infrastructure, you will have to apply the following steps:

In <b>variables.tf</b>:
  <ul>
    <li>variable "sharedcredslocation"
      <ul>
        <li>This is the <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared-credentials-file">Shared Credentials File</a></li>
        <li>The default location for this file is in "/Users/<i>gebruiker</i>/.aws/credentials"</li>
		<li>Example: "/Users/chall/.aws/credentials"</li>
      </ul>
    </li>
    <li>variable "public_key"
      <ul>
        <li>This is the <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair">Public Key</a></li>
        <li>Has to be in <a href="https://sectigo.com/resource-library/what-is-an-ssh-key">SSH-RSA</a> format</li>
      </ul>
    </li>
    <li>variable "private_key"
      <ul>
        <li>The path to the private key</li>
        <li>Example: "keys/mounir.pem"</li>
      </ul>
    </li>
    
  </ul>
