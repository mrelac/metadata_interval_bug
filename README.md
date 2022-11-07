# Library: [`JustAudio`](https://github.com/ryanheise/just_audio)

## Bug:
`IcyMetadata.Info` can be stale (e.g. doesn't match `IcyMetadata.Headers`)
## Possibly related bugs:


## Platform:
Discovered on _Android_ platform. Not verified on any other platform.

## Developer reporting bug:
Mike Relac

## Description:
Certain `IcyMetadata` streams served up by `JustAudio` can become out-of-sync such that the `IcyMetadata.Info` content doesn't get updated to match the `IcyMetadata.Headers` content. In testing, the `IcyMetadata.Headers` always looked correct. However, when a stream's `IcyMetadata.Headers.metadataInterval` was _**-1**_, the `IcyMetadata.Info` served up appeared to be the content of the previous `JustAudio` stream. This is the only condition I've found where this happens.

## Steps to reproduce:
*Note: flutter console output for the following steps is shown at the bottom of this document. A sample project visualizing this bug may be found at [metadata_interval_bug](https://github.com/mrelac/metadata_interval_bug).*
Steps are:
1. Using `JustAudio` with a component that dumps `IcyMetadata` content, play radio station **WETF** at
 https://ssl-proxy.icastcenter.com/get.php?type=Icecast&server=199.180.72.2&port=9007&mount=/stream&data=mp3.
1. Look at the IcyMetadata headers and info. Note that:
    - `IcyMetadata.Headers.name` is '*WETF The Jazz Station*'
    - `IcyMetadata.Headers.metadataInterval` is *-1*.
    - `IcyMetadata.Info:` is null
1. Now play radio station **KCSM** at https://ice5.securenetsystems.net/KCSM. This url ends in **KCSM**, so I assume the headers are correct as there is no helpful header content to verify this.
1. Look at the IcyMetadata headers and info. Note that:
    - `IcyMetadata.Headers` is not null.
    - `IcyMetadata.Info.title:` is not null and correctly describes the currently playing song.
1. Now go back to radio station **WETF** and play it.
1. Look at the IcyMetadata headers and info. Note that:
    - `IcyMetadata.Headers.name` is '*WETF The Jazz Station*'
    - `IcyMetadata.Headers.metadataInterval` is *-1*.
    - `IcyMetadata.Info:` is **NO LONGER** null, and that `IcyMetadata.Info.title` has the same content (song) as **KCSM**.
1. To further test against another station that correctly serves up an empty `IcyMetadata.Info.title`, play radio station **WDCB** at https://wdcb-ice.streamguys1.com/wdcb128. Note that `IcyMetadata.Headers` and `IcyMetadata.Info` are not null, though `title` is an empty string.

## Notes
Is it possible that the `IcyMetadata.Headers.metadataInterval` value of **-1** is being used to load the `info` content and is causing the previous stream's data to be returned? I have not yet found the underlying code to check but would be glad to help, given some direction on where to look

## Flutter console info output
### Step 1, Fresh run, WETF selected (url https://ssl-proxy.icastcenter.com/get.php?type=Icecast&server=199.180.72.2&port=9007&mount=/stream&data=mp3). Notice the last line - 'Icy info is null'.
```
I/flutter ( 7864): 2022-11-07 18:07:05.052154: icyMetadata:
I/flutter ( 7864): icy headers: bitrate: 128000
I/flutter ( 7864): icy headers: genre: Jazz
I/flutter ( 7864): icy headers: isPublic: true
I/flutter ( 7864): icy headers: metadataInterval: -1
I/flutter ( 7864): icy headers: name: WETF The Jazz Station
I/flutter ( 7864): icy headers: url: http://www.WETFTheJazzStation.org
I/flutter ( 7864): icy info is null
```
### Step 2 - KCSM selected (url https://ice5.securenetsystems.net/KCSM)
```
I/flutter ( 7864): 2022-11-07 18:07:58.071056: icyMetadata:
I/flutter ( 7864): icy headers: bitrate: 64000
I/flutter ( 7864): icy headers: genre: Rock
I/flutter ( 7864): icy headers: isPublic: true
I/flutter ( 7864): icy headers: metadataInterval: 16000
I/flutter ( 7864): icy headers: name: Streaming by Securenet Systems Cirrus(R)
I/flutter ( 7864): icy headers: url: http://rss.securenetsystems.net
I/flutter ( 7864): icy info: title: Charles McPherson - Manhattan Nocturne
I/flutter ( 7864): icy info: url: null
```
### Step 3 - WETF selected again. Notice the last two lines: `icy.info` is no longer null, and `info.title` contains the title (song) from KCSM above.
```
I/flutter ( 7864): 2022-11-07 18:08:14.725006: icyMetadata:
I/flutter ( 7864): icy headers: bitrate: 128000
I/flutter ( 7864): icy headers: genre: Jazz
I/flutter ( 7864): icy headers: isPublic: true
I/flutter ( 7864): icy headers: metadataInterval: -1
I/flutter ( 7864): icy headers: name: WETF The Jazz Station
I/flutter ( 7864): icy headers: url: http://www.WETFTheJazzStation.org
I/flutter ( 7864): icy info: title: Charles McPherson - Manhattan Nocturne
I/flutter ( 7864): icy info: url: null
```
### Step 4 - WDCB selected (url https://wdcb-ice.streamguys1.com/wdcb128)
```
I/flutter ( 7864): 2022-11-07 18:08:31.125637: icyMetadata:
I/flutter ( 7864): icy headers: bitrate: -1
I/flutter ( 7864): icy headers: genre: Jazz Variety
I/flutter ( 7864): icy headers: isPublic: false
I/flutter ( 7864): icy headers: metadataInterval: 16000
I/flutter ( 7864): icy headers: name: WDCB
I/flutter ( 7864): icy headers: url: www.wdcb.org
I/flutter ( 7864): icy info: title:
I/flutter ( 7864): icy info: url: null
```

### Step 4 - WETF selected again. Notice the last two lines: again, `icy.info` is not null, and `info.title` contains the *empty* title (song) from WDCB above.
```
I/flutter ( 7864): 2022-11-07 18:08:41.010954: icyMetadata:
I/flutter ( 7864): icy headers: bitrate: 128000
I/flutter ( 7864): icy headers: genre: Jazz
I/flutter ( 7864): icy headers: isPublic: true
I/flutter ( 7864): icy headers: metadataInterval: -1
I/flutter ( 7864): icy headers: name: WETF The Jazz Station
I/flutter ( 7864): icy headers: url: http://www.WETFTheJazzStation.org
I/flutter ( 7864): icy info: title:
I/flutter ( 7864): icy info: url: null
```