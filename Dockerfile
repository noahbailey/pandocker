FROM debian:buster 

RUN apt-get update && \
    apt-get install -y \
        pandoc texlive-full

ENTRYPOINT  pandoc -V geometry:margin=1in -o /home/output/output.pdf /home/input/input.md
