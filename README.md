# Homebrew tap for XarQ

[XarQ](https://xarq.org) is a vector illustration and page layout app descended from Xara.

## Install

Needs a Mac with Apple Silicon (M1 or later).

```sh
brew install xarq-design/xarq/xarq
```

Then add it to your Applications folder:

```sh
ln -sf "$(brew --prefix)/opt/xarq/XarQ.app" /Applications/XarQ.app
```

You can also start it from a terminal with `xarq`.

To follow the main branch instead of the latest release:

```sh
brew install --HEAD xarq-design/xarq/xarq
```

## Notes

- Prebuilt bottles exist for macOS 15 and 26 on Apple Silicon. On older versions Homebrew builds XarQ from source.
- Intel Macs aren't supported: Homebrew no longer ships prebuilt Intel versions of Qt and the other libraries XarQ needs, so installing would mean compiling all of them.
- PDF, DWG, GDAL, Graphviz and the formats XarQ loads at runtime (camera RAW, ICC profiles, JPEG 2000, JPEG XL, archives, DjVu) aren't enabled in this build yet.
- Linux users can use the AppImage from the [releases page](https://github.com/XarQ-design/xarq/releases) instead.
