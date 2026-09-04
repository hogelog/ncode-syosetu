# ncode-syosetu
[![Test](https://github.com/hogelog/ncode-syosetu/actions/workflows/test.yml/badge.svg)](https://github.com/hogelog/ncode-syosetu/actions/workflows/test.yml)
[![Gem Version](https://badge.fury.io/rb/ncode-syosetu.svg)](http://badge.fury.io/rb/ncode-syosetu)

ncode.syosetu.com content converter.

## Gems

- [`ncode-syosetu`](ncode-syosetu): An integrated package for converting novels to various formats from the command line
- [`ncode-syosetu-core`](ncode-syosetu-core): Core library for fetching and parsing novels from Syosetu
- [`ncode-syosetu-epub3`](ncode-syosetu-epub3): Converts novels to EPUB 3 format
- [`ncode-syosetu-ssml`](ncode-syosetu-ssml): Converts novel text to SSML
- [`ncode-syosetu-polly`](ncode-syosetu-polly): Converts novel text to audio files using Amazon Polly
- [`ncode-syosetu-mobi`](ncode-syosetu-mobi): Deprecated; MOBI conversion is no longer available

## Install
```
# gem install ncode-syosetu
```

## Usage
```
$ ncode2epub n0000aa # http://ncode.syosetu.com/n0000aa -> n0000aa.epub
$ ncode2mp3 n0000aa 1 # http://ncode.syosetu.com/n0000aa/1/ -> n0000aa-1.mp3
```
