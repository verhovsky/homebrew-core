class Vcglib < Formula
  desc "Open source triangle mesh manipulation library in C++"
  homepage "http://vcg.isti.cnr.it/vcglib/"
  url "https://github.com/cnr-isti-vclab/vcglib/archive/refs/tags/2022.02.tar.gz"
  sha256 "724f5ef6ab9b9d21ff2e9e965c2ce909cc024b29f2aa7d39e2974b28ff25bc3f"
  license "GPL-3.0"
  head "https://github.com/cnr-isti-vclab/vcglib.git", branch: "main"

  conflicts_with "eigen", because: "vcglib ships its own copy of eigen"

  def install
    rm_rf Dir[".github", "docs", "apps"]
    prefix.install Dir["*"]
  end
end
