# terraform by Mounir Challouk
To use thsi Terraform infrastructure, you will have to apply the following steps:

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
