class Openmvs < Formula
  desc "Open source Multi-View Stereo reconstruction library"
  homepage "https://cdcseacave.github.io/"
  url "https://github.com/cdcseacave/openMVS/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "c09f5741abeae8b3f9da91ded943ab10aafa60567b68e6f7bec81014e1375901"
  license "AGPL-3.0"
  head "https://github.com/cdcseacave/openMVS.git", branch: "master"

  depends_on xcode: :build
  depends_on :macos
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "opencv"
  depends_on "cgal"
  depends_on "ceres-solver"
  depends_on "libomp"
  depends_on "vcglib"

  def install
    args = std_cmake_args + %W[
      -DVCG_ROOT='#{Formula["vcglib"].opt_prefix}'
    ]
    system "cmake", "-S", ".", "-B", "build", "-G", "Xcode", *args
    cd "build" do
      xcodebuild "-configuration", "Release",
                "SYMROOT=build",
                "-arch", Hardware::CPU.arch

      bin.install "build/Release/InterfaceVisualSFM"
      bin.install "build/Release/DensifyPointCloud"
      bin.install "build/Release/ReconstructMesh"
      bin.install "build/Release/RefineMesh"
      bin.install "build/Release/TextureMesh"
    end
    # TODO: the rest
  end

  test do
    system "#{bin}/InterfaceVisualSFM", "--help"
    system "#{bin}/DensifyPointCloud", "--help"
    system "#{bin}/ReconstructMesh", "--help"
    system "#{bin}/RefineMesh", "--help"
    system "#{bin}/TextureMesh", "--help"
  end
end
