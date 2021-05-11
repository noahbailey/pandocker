# Pandocker - CI for Docs

![](https://img.shields.io/docker/cloud/build/noahbailey/pandocker) ![](https://github.com/noahbailey/pandocker/actions/workflows/docker-publish.yml/badge.svg)


Pandoc for Docker. This container performs one function, convert a Markdown file to a PDF. This can be used to generate documents or produce printable versions of web documentation. 

## Usage

The container builds a single document at a time, then exits with code 0. 

### Files

`input/input.md` is the file which will be converted. 

`output/output.md` is the resulting PDF file. 

## Configuration

A simple implementation would be using pandocker with Docker-compose to convert a file: 

```yaml
---
version: "3"
services: 
  build:
    image: noahbailey/pandocker:latest
    volumes: 
      - ./my-cool-file.md:/home/input/input.md:ro
      - ./output:/home/output:rw
```

### CI mode

This can be combined with GitHub Actions to auto-build markdown files: 

```yaml
name: Build image and email PDF

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Render PDF file
      run: docker-compose up
    - name: Send mail
      uses: dawidd6/action-send-mail@v3
      with:
        server_address: smtp.mailgun.org
        server_port: 587
        username: ${{secrets.MAIL_USERNAME}}
        password: ${{secrets.MAIL_PASSWORD}}
        subject: "Document build was successful. See attachment!"
        to: ${{secrets.MAILTO}}
        from: DocBuildBot
        body: Build job of ${{github.repository}} completed successfully!
        attachments: ${{ github.workspace }}/output/output.pdf
```

Once the CI run is complete, the document will be emailed to the address specified by the "MAILTO" environment variable in the repository. 
