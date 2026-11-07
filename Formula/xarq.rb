class Xarq < Formula
  desc "Vector illustration and page layout app descended from Xara"
  homepage "https://xarq.org"
  url "https://github.com/jonata/xarq/archive/refs/tags/v26.10-alpha.tar.gz"
  sha256 "694505724f1cc60fd794cbe171e6a7e0cfa36c0a1dca95ff35dc2dd2957a33dc"
  license all_of: ["GPL-2.0-only", "OFL-1.1", "Ubuntu-font-1.0"]
  head "https://github.com/jonata/xarq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-[a-z]+\d*)?)$/i)
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "harfbuzz"
  # Each of these turns on one more vector import format (CorelDRAW, iWork,
  # FreeHand, Publisher, legacy Mac, PageMaker, Visio, WordPerfect Graphics).
  depends_on "libcdr"
  depends_on "libetonyek"
  depends_on "libfreehand"
  depends_on "libmspub"
  depends_on "libmwaw"
  depends_on "libpagemaker"
  depends_on "librevenge"
  depends_on "libvisio"
  depends_on "libwpg"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DXARQ_VERSION=#{version}
      -DXARQ_GDAL=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_GDCM=ON
    ]
    # Clang makes narrowing inside braces an error, where GCC only warns.
    args << "-DCMAKE_CXX_FLAGS=-Wno-narrowing"

    system "cmake", "-S", "src", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    if OS.mac?
      contents = prefix/"XarQ.app/Contents"
      (contents/"MacOS").install "build/xarq"
      icon = buildpath/"src/assets/logo/xarq-appicon.icns"
      (contents/"Resources").install icon => "XarQ.icns" if icon.exist?
      (contents/"Info.plist").write info_plist
      bin.install_symlink contents/"MacOS/xarq"
    else
      bin.install "build/xarq"
      (share/"applications").install "src/assets/xarq.desktop"
      (share/"icons/hicolor/scalable/apps").install "src/assets/logo/xarq-appicon.svg" => "xarq.svg"
    end
  end

  def info_plist
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>en</string>
        <key>CFBundleDisplayName</key>
        <string>XarQ</string>
        <key>CFBundleExecutable</key>
        <string>xarq</string>
        <key>CFBundleIconFile</key>
        <string>XarQ</string>
        <key>CFBundleIdentifier</key>
        <string>org.xarq.XarQ</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>XarQ</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>#{version}</string>
        <key>CFBundleVersion</key>
        <string>#{version}</string>
        <key>NSHighResolutionCapable</key>
        <true/>
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
        <key>CFBundleDocumentTypes</key>
        <array>
          <dict>
            <key>CFBundleTypeName</key>
            <string>Xara document</string>
            <key>CFBundleTypeExtensions</key>
            <array>
              <string>xar</string>
              <string>web</string>
            </array>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>LSHandlerRank</key>
            <string>Owner</string>
          </dict>
        </array>
      </dict>
      </plist>
    XML
  end

  def caveats
    on_macos do
      <<~EOS
        XarQ.app was installed to:
          #{opt_prefix}/XarQ.app

        To add it to your Applications folder, run:
          ln -sf #{opt_prefix}/XarQ.app /Applications/XarQ.app
      EOS
    end
  end

  test do
    (testpath/"in.svg").write <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="40" height="30">
        <rect x="5" y="5" width="30" height="20" fill="#e33"/>
      </svg>
    SVG
    ENV["QT_QPA_PLATFORM"] = "offscreen"
    system bin/"xarq", "--open", testpath/"in.svg", "--export", testpath/"out.png"
    assert_equal "\x89PNG".b, (testpath/"out.png").binread(4)
  end
end
