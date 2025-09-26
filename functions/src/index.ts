import {onCall} from "firebase-functions/v2/https";
import {logger} from "firebase-functions";

interface Track {
  title: string;
  artist: string;
  albumArtUrl: string;
}

const mockPlaylists: {[key: string]: Track[]} = {
  chill: [
    {title: "Chill Vibes", artist: "Lo-Fi Girl", albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304"},
    {title: "Relaxing Rain", artist: "Ambient Sounds", albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304"},
  ],
  energetic: [
    {title: "Pump Up", artist: "Workout Beats", albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304"},
  ],
  default: [
    {title: "Sample Track 1", artist: "Artist 1", albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304"},
    {title: "Sample Track 2", artist: "Artist 2", albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304"},
    {title: "Sample Track 3", artist: "Artist 3", albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304"},
    {title: "Sample Track 4", artist: "Artist 4", albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304"},
    {title: "Sample Track 5", artist: "Artist 5", albumArtUrl: "https://i.scdn.co/image/ab67616d0000b273e3335c833d07f354f9a46304"},
  ],
};

export const generatePlaylist = onCall({region: "us-central1"}, async (request) => {
  logger.info("generatePlaylist called with mood:", request.data.mood);

  const {mood} = request.data as {mood: string};

  if (!mood || typeof mood !== "string") {
    throw new Error("Mood is required and must be a string.");
  }


  const lowerMood = mood.toLowerCase().trim();
  let tracks: Track[] = mockPlaylists.default;

  if (lowerMood.includes("chill") || lowerMood.includes("relax")) {
    tracks = mockPlaylists.chill;
  } else if (lowerMood.includes("energetic") || lowerMood.includes("upbeat")) {
    tracks = mockPlaylists.energetic;
  }
 

  logger.info("Generated " + tracks.length + " tracks for mood: " + mood.substring(0, 20) + "...");

  return tracks;
});
