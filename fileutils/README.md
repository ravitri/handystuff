# File Util scripts

The repository has list of one-liner commands which proved to be very handy when dealing with multiple files.

## 1. Compress pdf file to a smaller size
```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=<new_compressed_file>.pdf <original_file>.pdf
```

## 2. Convert a list of .jpg files to .pdf files in a directory maintaining original name
```bash
for file in 00{1..5}; do echo $file; convert ${file}.jpg ${file}.pdf;done
```

## 3. Extract music from audio file using command line
```bash
#ffmpeg -i input.mp4 -ss <start-time> -t <duration> -q:a 0 -map a output.mp3
ffmpeg -i input.mp4 -ss 00:00:00 -t 00:00:30.0 -q:a 0 -map a output.mp3
```

## 4. Merge multiple PDF files into one PDF file
```bash
pdfunite pdf1.pdf pdf2.pdf pdf3.pdf merged.pdf
```
