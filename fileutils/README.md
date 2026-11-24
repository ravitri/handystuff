# File Util scripts

One-liner commands that are handy when dealing with many files.

## 1. Compress a PDF file to a smaller size
```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=<new_compressed_file>.pdf <original_file>.pdf
```
`-dPDFSETTINGS` controls quality: `/screen` (smallest), `/ebook` (medium), `/printer` or `/prepress` (high).

## 2. Convert every .jpg file in a directory to .pdf, keeping the original name
```bash
for f in *.jpg; do convert "$f" "${f%.jpg}.pdf"; done
```
With ImageMagick 7, use `magick` instead of `convert`. If you get a "not authorized" error,
your distro's ImageMagick `policy.xml` blocks PDF output. Use `img2pdf` instead, which also
doesn't re-encode the image:
```bash
for f in *.jpg; do img2pdf "$f" -o "${f%.jpg}.pdf"; done
```

## 3. Extract audio from a video file
```bash
# ffmpeg -ss <start-time> -i input.mp4 -t <duration> -q:a 0 -map a output.mp3
ffmpeg -ss 00:00:00 -i input.mp4 -t 00:00:30.0 -q:a 0 -map a output.mp3
```
Putting `-ss` before `-i` seeks the input directly, which is much faster on long files.

## 4. Merge multiple PDF files into one PDF file
```bash
pdfunite pdf1.pdf pdf2.pdf pdf3.pdf merged.pdf
```
Alternative using `qpdf`:
```bash
qpdf --empty --pages pdf1.pdf pdf2.pdf pdf3.pdf -- merged.pdf
```
