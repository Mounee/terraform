# terraform
Om deze Terraform infrastructure te gebruiken, moet u het onderstaande aanpassen:

In <b>variables.tf</b>:
  <ul>
    <li>variable "sharedcredslocation"
      <ul>
        <li>Dit is de <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared-credentials-file">Shared Credentials File</a></li>
        <li>Dit bestand staat standaard in "/Users/<i>gebruiker</i>/.aws/credentials"</li>
      </ul>
    </li>
    <li>variable "public_key"
      <ul>
        <li>Dit is de <a href="https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair">Public Key</a></li>
        <li>Moet in SSH-RSA format</li>
		<li>Voorbeeld: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbSsj7eFIGgzweCrMHgkc4ZVrCskLb6pjcw9PR1bgW70rPW8PFCOxtT+ZwLqjT6hlBJSgHBLYgkJgLR/zdVcd/LuX0HmFxNw9fm03aR5SpXVI1uPirVxP2pihUnJkak68nJPGMSr3phqKoihm/Mog4F0ohutLYcHCb3oqXE0PlLY/jhdnYGW8XAYplG8PdQidNvX7MjYgoRYtIiVa3c0k59NZPWGzqLHCypq0RIuLtptpoilipJ5YzVFJMBQJseWL2BmQB6js3nAtAhhvpXuAL/2ZAHfqucZvszghHxMIx61qxXkQCASIq+/c/5bNfO00mCMa8Y/yVG5kQabPxgawV"</li>
      </ul>
    </li>
    <li>variable "private_key"
      <ul>
        <li>Het pad naar de private key</li>
        <li>Voorbeeld: "keys/mounir.pem"</li>
      </ul>
    </li>
    
  </ul>
