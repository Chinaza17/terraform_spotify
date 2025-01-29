resource "spotify_playlist" "country_music" {
    name = "blues"
    tracks = ["6mqdunuFFSODHKcpDTFvAj"]
}
 
 data "spotify_search_track" "kizzdaniel" {
    artist  =   "Kizz daniel"
 }
    
resource "spotify_playlist" "afrobeats" {
  name  =   "afrobeats"
  tracks =  [data.spotify_search_track.kizzdaniel.tracks[0].id,
  data.spotify_search_track.kizzdaniel.tracks[1].id,
  data.spotify_search_track.kizzdaniel.tracks[3].id]

}