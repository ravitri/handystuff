# handystuff
The repository has list of small commands which proved to be very handy in regular work on a Linux machine.

## 1. Compress pdf file to a smaller size
```bash
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=<new_compressed_file>.pdf <original_file>.pdf
```

## 2. Convert a list of .jpg files to .pdf files in a directory maintaining original name
```bash
for file in 00{1..5}; do echo $file; convert ${file}.jpg ${file}.pdf;done
```
