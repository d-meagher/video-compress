#!/bin/bash

# Prompt for the video URL
read -p "Enter the video URL: " video_url

# Use yt-dlp to download the highest quality video file
echo "Downloading video..."
yt-dlp -f "bestvideo+bestaudio" -o "input.%(ext)s" "$video_url"

# Get the name of the downloaded file
input_file=$(ls input.* | head -n 1)

# Prompt for output file name
read -p "Enter the output file name (e.g., output_video): " output_file

# Ensure the output file ends with .mp4
output_file="${output_file%.mp4}.mp4"

# Prompt for output resolution (4K, 1080p, or 9:16 1080p)
echo "Select output resolution:"
echo "1) 4K"
echo "2) 1080p"
echo "3) 9:16 1080p"
read -p "Pick your resolution: " resolution_choice

# Set resolution-specific variables
if [ "$resolution_choice" == "1" ]; then
    video_bitrate="18M"
    scale="3840:2160"
    hdr_filter="format=yuv420p10le"  # Retain HDR for 4K
elif [ "$resolution_choice" == "2" ]; then
    video_bitrate="14M"
    scale="1920:1080"
    hdr_filter="format=yuv420p"      # Remove HDR for standard 1080p
elif [ "$resolution_choice" == "3" ]; then
    video_bitrate="10M"
    scale="1080:1920"
    crop="crop=1080:1920"
    hdr_filter="format=yuv420p10le"  # Retain HDR for 9:16 1080p
else
    echo "Invalid choice. Exiting."
    exit 1
fi

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
if [ "$resolution_choice" == "3" ]; then
  ffmpeg -i "$input_file" \
    -ss "$trim_start" -to "$end_time" \
    -vf "crop=1080:1920:(in_w-1080)/2:(in_h-1920)/2,scale=$scale,$hdr_filter" \
    -c:v h264_videotoolbox -allow_sw 1 \
    -b:v "$video_bitrate" \
    -r 30 \
    -c:a aac -b:a 128k \
    -f mp4 \
    "$output_file"
else
  ffmpeg -i "$input_file" \
    -ss "$trim_start" -to "$end_time" \
    -vf "scale=$scale,$hdr_filter" \
    -c:v h264_videotoolbox -allow_sw 1 \
    -b:v "$video_bitrate" \
    -r 30 \
    -c:a aac -b:a 128k \
    -f mp4 \
    "$output_file"
fi

# Clean up the downloaded file
rm "$input_file"