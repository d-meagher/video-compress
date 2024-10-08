# README

## Overview

This repository contains a single bash script designed to download, trim, and convert videos from a provided URL using `yt-dlp` and `ffmpeg`. The script automates the process of downloading a video, removing portions from the beginning and/or end, and exporting the result as a high-quality MP4 file.

## Prerequisites

Before running the script, ensure you have the following dependencies installed:

1. **yt-dlp**: A command-line program to download videos from YouTube and other websites.
   - [yt-dlp GitHub](https://github.com/yt-dlp/yt-dlp)

2. **ffmpeg**: A powerful tool to record, convert, and stream audio and video.
   - [FFmpeg Official Website](https://ffmpeg.org/)

On a Linux system, you can install these using:
```bash
sudo apt-get install yt-dlp ffmpeg
```

## Usage

To use this script, follow the steps below:

1. **Make the script executable** (if not already):
   ```bash
   chmod +x <script-name>.sh
   ```

2. **Run the script**:
   ```bash
   ./<script-name>.sh
   ```

3. The script will prompt for the following inputs:

   - **Video URL**: Provide the URL of the video you want to download.
   - **Output file name**: Specify the name of the output file (without the `.mp4` extension).
   - **Seconds to trim from the beginning**: Optionally, specify how many seconds to trim from the start of the video (default is 0).
   - **Seconds to trim from the end**: Optionally, specify how many seconds to trim from the end of the video (default is 0).

4. The script will:
   - Download the video in the highest available quality using `yt-dlp`.
   - Use `ffmpeg` to trim the specified portions from the video.
   - Save the output in the desired MP4 format with h.264 video encoding, AAC audio encoding, and specific bitrate settings.
   - Delete the original downloaded file to save space.

### Example Workflow

```
$ ./download_trim_convert.sh
Enter the video URL: https://www.example.com/video
Downloading video...
Enter the output file name (e.g., output_4k2): my_video
Enter seconds to trim from the beginning (default is 0): 5
Enter seconds to trim from the end (default is 0): 10
```

This example would download the video, trim 5 seconds from the start and 10 seconds from the end, then output it as `my_video.mp4`.

## Script Breakdown

1. **Download the video**: The script uses `yt-dlp` to download the best available quality video and audio combination into a file named `input.<extension>`.

2. **Video Trimming**:
   - Prompts for user input to determine how many seconds to trim from the beginning and end of the video.
   - Extracts the video's total duration using `ffmpeg` and calculates the new end time.

3. **Conversion**:
   - Uses `ffmpeg` to encode the video using h.264 and AAC codecs, with a video bitrate of 18M, and outputs the video at 30 frames per second in an `.mp4` container.

4. **Cleanup**: The original downloaded file is deleted after processing to avoid unnecessary disk usage.

## Notes

- The script assumes the video URL is valid and that the desired output file ends with `.mp4`.
- It uses `h264_videotoolbox` for video encoding, which works efficiently on Apple hardware. If you are running this script on other platforms, you might need to adjust the codec (`-c:v` option).

## License

This project is provided as-is without any explicit license. You are free to use, modify, and distribute it as needed.