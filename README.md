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
      </ul>
    </li>
    <li>variable "private_key"
      <ul>
        <li>Het pad naar de private key</li>
        <li>Voorbeeld: "keys/mounir.pem"</li>
      </ul>
    </li>
    
  </ul>
