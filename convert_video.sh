#!/bin/bash

# Prompt for the video URL
read -p "Enter the video URL: " video_url

# Use yt-dlp to download the highest quality video file
echo "Downloading video..."
yt-dlp -f "bestvideo+bestaudio" -o "input.%(ext)s" "$video_url"

# Get the name of the downloaded file
input_file=$(ls input.* | head -n 1)

# Prompt for output file name
read -p "Enter the output file name (e.g., output_4k2): " output_file

# Ensure the output file ends with .mp4
output_file="${output_file%.mp4}.mp4"

# Prompt for seconds to trim from the beginning
read -p "Enter seconds to trim from the beginning (default is 0): " trim_start_input
trim_start=${trim_start_input:-0}  # Default to 0 if no input

# Prompt for seconds to trim from the end
read -p "Enter seconds to trim from the end (default is 0): " trim_end_input
trim_end=${trim_end_input:-0}  # Default to 0 if no input

# Calculate the end time by subtracting trim_end from the total duration
duration=$(ffmpeg -i "$input_file" 2>&1 | grep "Duration" | awk '{print $2}' | tr -d ,)
total_seconds=$(echo $duration | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
end_time=$(echo "$total_seconds - $trim_end" | bc)

# Run the ffmpeg command
ffmpeg -i "$input_file" \
  -ss "$trim_start" -to "$end_time" \
  -c:v h264_videotoolbox -allow_sw 1 \
  -b:v 18M \
  -r 30 \
  -c:a aac -b:a 128k \
  -f mp4 \
  "$output_file"

# Clean up the downloaded file
rm "$input_file"
