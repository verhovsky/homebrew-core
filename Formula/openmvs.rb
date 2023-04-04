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
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
    ]
    # "there are no SSE extensions on ARM"
    # https://github.com/cdcseacave/openMVS/issues/921#issuecomment-1369792801
    # https://github.com/mapillary/OpenSfM/issues/766#issuecomment-915569061
    args << '-DOpenMVS_USE_SSE=OFF' if Hardware::CPU.arm?

    if OS.mac?
      libomp = Formula["libomp"]
      boost = Formula["boost"]
      libpng = Formula["libpng"]
      libjpeg = Formula["jpeg"]
      libtiff = Formula["libtiff"]
      cgal = Formula["cgal"]
      gmp = Formula["gmp"]
      mpfr = Formula["mpfr"]

      args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include} -I#{boost.opt_include} -I#{libpng.opt_include} -I#{libjpeg.opt_include} -I#{libtiff.opt_include} -I#{cgal.opt_include} -I#{gmp.opt_include} -I#{mpfr.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include} -I#{boost.opt_include} -I#{libpng.opt_include} -I#{libjpeg.opt_include} -I#{libtiff.opt_include} -I#{cgal.opt_include} -I#{gmp.opt_include} -I#{mpfr.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
      args << "-DCMAKE_EXE_LINKER_FLAGS=-L#{boost.opt_lib}"
      args << "-DCMAKE_SHARED_LINKER_FLAGS=-L#{boost.opt_lib}"
      args << "-DCMAKE_MODULE_LINKER_FLAGS=-L#{boost.opt_lib}"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Xcode", *args
    cd "build" do
      xcodebuild "-configuration", "Release",
                "SYMROOT=build",
                "-arch", Hardware::CPU.arch

      bin.install "build/Release/InterfaceCOLMAP"
      bin.install "build/Release/InterfaceMVSNet"
      bin.install "build/Release/InterfaceMetashape"
      # bin.install "build/Release/InterfaceVisualSFM"

      bin.install "build/Release/DensifyPointCloud"
      bin.install "build/Release/ReconstructMesh"
      bin.install "build/Release/RefineMesh"
      bin.install "build/Release/TextureMesh"
      bin.install "build/Release/TransformScene"

    end
  end

  test do
    system "build/Release/Tests"

    system "#{bin}/InterfaceCOLMAP", "--help"
    system "#{bin}/InterfaceMVSNet", "--help"
    system "#{bin}/InterfaceMetashape", "--help"
    # system "#{bin}/InterfaceVisualSFM", "--help"

    system "#{bin}/DensifyPointCloud", "--help"
    system "#{bin}/ReconstructMesh", "--help"
    system "#{bin}/RefineMesh", "--help"
    system "#{bin}/TextureMesh", "--help"
    system "#{bin}/TransformScene", "--help"
  end
end
