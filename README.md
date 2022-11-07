# Library: [`JustAudio`](https://github.com/ryanheise/just_audio)

## Bug:
`IcyMetadata.Info` can be stale (e.g. doesn't match `IcyMetadata.Headers`)

## Platform:
Discovered on _Android_ platform. Not verified on any other platform.

## Developer reporting bug:
Mike Relac

## Description:
Certain `IcyMetadata` streams served up by `JustAudio` can become out-of-sync such that the `IcyMetadata.Info` content doesn't get updated to match the `IcyMetadata.Headers` content. In testing, the `IcyMetadata.Headers` always looked correct. However, when a stream's `IcyMetadata.Headers.metadataInterval` was _**-1**_, the `IcyMetadata.Info` served up appeared to be the content of the previous `JustAudio` stream. This is the only condition I've found where this happens.

## Steps to reproduce:
*Note: The flutter project [metadata_interval_bug](https://github.com/mrelac/metadata_interval_bug) provides an easy way to visualize this bug.*
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
