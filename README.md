**Create a Spotify playlist with Terrafom**


<img width="416" alt="image" src="https://github.com/user-attachments/assets/96381e1c-23bf-4923-bc56-33a0e50cbee6" />
<img width="415" alt="image" src="https://github.com/user-attachments/assets/892d8b2c-0063-41f1-9b3f-2c110b08e811" />






Terraform manages infrastructure on cloud computing providers such as AWS, Azure, and GCP. But, it can also manage resources in hundreds of other services, including the music service Spotify.
In this tutorial, you will use a Terraform data source to search Spotify for an artist, album, or song, and use that data to build a playlist.

**Prerequisites**

To complete this tutorial, you will need:
Terraform version 1.0+
Docker Desktop
Spotify account with developer access

**Create Spotify developer app**

Before you can use Terraform with Spotify, you need to create a Spotify developer app and run Spotify's authorization proxy server.
Login to the Spotify developer dashboard.

<img width="416" alt="image" src="https://github.com/user-attachments/assets/d81430ad-468f-47ca-a8b9-3c3342311652" />



Click the green Create an app button.
Fill out the name and description according to the table below, check the box to agree to the terms of services, then click Create.
**Name**	**Description**
Terraform Playlist Demo	Create a Spotify playlist using Terraform. Follow the tutorial at learn.hashicorp.com/tutorials/terraform/spotify-playlist

<img width="416" alt="image" src="https://github.com/user-attachments/assets/0aef24ac-a55c-4d12-8563-8948e1fcf6b5" />



Once Spotify creates the application, find and click the green Edit Settings button on the top right side.
Copy the URI below into the Redirect URI field and click Add so that Spotify can find its authorization application locally on port 27228 at the correct path. Scroll to the bottom of the form and click Save.
http://localhost:27228/spotify_callback



**Run authorization server**

Now that you created the Spotify app, you are ready to configure and start the authorization proxy server, which allows Terraform to interact with Spotify.




Return to your terminal and set the redirect URI as an environment variable, instructing the authorization proxy server to serve your Spotify access tokens on port 27228.
$ export SPOTIFY_CLIENT_REDIRECT_URI=http://localhost:27228/spotify_callback
Next, create a file called .env with the following contents to store your Spotify application's client ID and secret.
SPOTIFY_CLIENT_ID=
SPOTIFY_CLIENT_SECRET=
Copy the Client ID from the Spotify app page underneath your app's title and description, and paste it into .env as your SPOTIFY_CLIENT_ID.

<img width="416" alt="image" src="https://github.com/user-attachments/assets/30bff23e-60fb-459f-bdfc-d9c8e1b643a1" />


Click Show client secret and copy the value displayed into .env as your SPOTIFY_CLIENT_SECRET.
Make sure Docker Desktop is running, and start the server. It will run in your terminal's foreground.
$ docker run --rm -it -p 27228:27228 --env-file ./.env ghcr.io/conradludgate/spotify-auth-proxyUnable to find image 'ghcr.io/conradludgate/spotify-auth-proxy:latest' locallylatest: Pulling from conradludgate/spotify-auth-proxy5843afab3874: Pull completeb244520335f6: Pull completeDigest: sha256:c738f59a734ac17812aae5032cfc6f799e03c1f09d9146edb9c283


6bc589f3dcStatus: Downloaded newer image for ghcr.io/conradludgate/spotify-auth-proxy:latestAPIKey: xxxxxx...Token:  xxxxxx...Auth:   http://localhost:27228/authorize?token=xxxxxx...
Visit the authorization server's URL by visiting the link that your terminal output lists after Auth:.
The server will redirect you to Spotify to authenticate. After authenticating, the server will display Authorization successful, indicating that the Terraform provider can use the server to retrieve access tokens.
Leave the server running.

**Explore the configuration**

Open main.tf. This file contains the Terraform configuration that searches Spotify and creates the playlist. The first two configuration blocks in the file:
configure Terraform itself and specify the community provider that Terraform uses to communicate with Spotify.
configure the Spotify provider with the key you set as a variable.
terraform {
  required_providers {
    spotify = {
      source = "conradludgate/spotify"
      version = "0.2.7"
    }
  }
}

provider "spotify" {
  # Configuration options
  api_key = var.api_key
}The next block defines a Terraform data source to search the Spotify provider for Dolly Parton songs.
data "spotify_search_track" "kizzdaniel" {
    artist  =   "Kizz daniel"
 }
The next block uses a Terraform resource to create a playlist from the first three songs that match the search in the data source block.
resource "spotify_playlist" "afrobeats" {
  name  =   "afrobeats"
  tracks =  [data.spotify_search_track.kizzdaniel.tracks[0].id,
  data.spotify_search_track.kizzdaniel.tracks[1].id,
  data.spotify_search_track.kizzdaniel.tracks[3].id]

}

**Set the API key**

Rename the terraform.tfvars.example file terraform.tfvars so that Terraform can detect the file.
$ mv terraform.tfvars.example terraform.tfvars
The .gitignore file in this repository excludes files with the .tfvars extension from version control to prevent you from accidentally committing your credentials.

**Warning**

Never commit sensitive values to version control.
Find the terminal window where the Spotify authorization proxy server is running and copy the APIKey from its output.
Open terraform.tfvars, and replace ... with the key from the proxy, so that Terraform can authenticate with Spotify. Save the file.
spotify_api_key = "..."
This variable is declared for you in variables.tf.
variable "spotify_api_key" {  type        = string  description = "Set this as the APIKey that the authorization proxy server outputs"}
Install the Spotify provider
In your terminal, initialize Terraform, which will install the Spotify provider.
$ terraform initInitializing the backend...Initializing provider plugins...- Finding conradludgate/spotify versions matching "~> 0.1.5"...- Installing conradludgate/spotify v0.1.5...- Installed conradludgate/spotify v0.1.5 (self-signed, key ID B4E4E68AFAC5D89C)Partner and community providers are signed by their developers.If you'd like to know more about provider signing, you can read about it here:https://www.terraform.io/docs/cli/plugins/signing.htmlTerraform has created a lock file .terraform.lock.hcl to record the providerselections it made above. Include this file in your version control repositoryso that Terraform can guarantee to make the same selections by default whenyou run "terraform init" in the future.Terraform has been successfully initialized!You may now begin working with Terraform. Try running "terraform plan" to seeany changes that are required for your infrastructure. All Terraform commandsshould now work.If you ever set or change modules or backend configuration for Terraform,rerun this command to reinitialize your working directory. If you forget, othercommands will detect it and remind you to do so if necessary.

**Create the playlist**


Now you are ready to create your playlist. Apply your Terraform configuration. Terraform will show you the changes it plans to make and prompt for your approval.

<img width="415" alt="image" src="https://github.com/user-attachments/assets/9d1120ba-ccf4-4a63-8685-41e208ffa71a" />

  
**Listen to your playlist**

<img width="415" alt="image" src="https://github.com/user-attachments/assets/36d3f474-e0bf-4989-b574-cc233ca1654a" />

<img width="415" alt="image" src="https://github.com/user-attachments/assets/efd5744c-42dc-4cd6-9a2a-afebb5b3885a" />






Open the playlist URL returned in the Terraform output and enjoy your playlist!
Customize and share!
Now that you have created a playlist using Terraform, build your own Spotify playlist. Terraform maintains a state file that allows it to manage the playlist you created. Change the playlist name, the artist, specify an album, or pick specific tracks with their Spotify song IDs or URLs. See the example below for inspiration.
When you are happy with your configuration, apply your changes to edit the playlist, and remember to confirm the plan that Terraform presents with a yes.
$ terraform apply
Explore the unofficial Spotify provider documentation for all the available configuration options.
