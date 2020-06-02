# Slack Util scripts
The repository has list of small commands which can be used in Slack

## 1. Create a "-intensifies" emoji out of any existing iamge file.
```bash
sudo dnf install ImageMagick.x86_64 -y
curl -s -L -O https://gist.githubusercontent.com/ravitri/f99b9f28266a35949b7d7b7980c2d683/raw/504f2effe54f34fd55291c122c9e621affae0797/intensify.sh
chmod +x intensify.sh
./intensify.sh <input-image.png>
```

`input-image-intensifies.gif` file will be created which can be uploaded to Slack as an emoji.
