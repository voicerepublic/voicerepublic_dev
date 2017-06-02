# wav2json docker

## Usage

There is a wrapper shell script in `bin/wav2json`. It will build the
docker image if nescessary. It takes the name of the wave file as the
first argument. The file has to reside in the current working
directory.

This will generate `improved_jingle.wav.json` in the same directory.
