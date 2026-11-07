# Homebrew tap for XarQ

[XarQ](https://xarq.org) is a vector illustration and page layout app descended from Xara.

## Install

```sh
brew install jonata/xarq/xarq
```

Then add it to your Applications folder:

```sh
ln -sf "$(brew --prefix)/opt/xarq/XarQ.app" /Applications/XarQ.app
```

You can also start it from a terminal with `xarq`.

To follow the main branch instead of the latest release:

```sh
brew install --HEAD jonata/xarq/xarq
```

## Notes

- Until bottles are published for your macOS version, Homebrew builds XarQ from source, which takes a while.
- PDF, DWG, GDAL, Graphviz and the formats XarQ loads at runtime (camera RAW, ICC profiles, JPEG 2000, JPEG XL, archives, DjVu) aren't enabled in this build yet.
- Linux users can use the AppImage from the [releases page](https://github.com/jonata/xarq/releases) instead.
