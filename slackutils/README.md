# Slack Util scripts

Small commands for making things to use in Slack.

## 1. Create an "-intensifies" emoji from any image file

Install ImageMagick:
```bash
sudo dnf install -y ImageMagick      # Fedora / RHEL
```
```bash
sudo apt-get install -y imagemagick  # Debian / Ubuntu
```
```bash
brew install imagemagick             # macOS
```

Download the script (pinned to a specific revision; read it before running):
```bash
curl -sSL -O https://gist.githubusercontent.com/ravitri/f99b9f28266a35949b7d7b7980c2d683/raw/504f2effe54f34fd55291c122c9e621affae0797/intensify.sh
chmod +x intensify.sh
```

Run it:
```bash
./intensify.sh <input-image.png>
```

This creates `input-image-intensifies.gif`, which you can upload to Slack as an emoji.
