class Libkrun < Formula
  desc "Dynamic library providing KVM-based process isolation capabilities"
  homepage "https://github.com/containers/libkrun"
  url "https://github.com/containers/libkrun/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "483f5579006d59212b9942b9ca39f03c6305940129d99925ecc979b1e6754711"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/slp/homebrew-krun/releases/download/libkrun-1.18.1"
    sha256 cellar: :any, arm64_tahoe:   "ffc6cc9a2c2089b267aa4e7884574e0b992fedb8e4a72b63726883743697af3f"
    sha256 cellar: :any, arm64_sequoia: "d3e4aa7707d90ecdbb58e0c1be1bf44082222ba974c14850053c7513a8bd85c5"
  end

  depends_on "lld" => :build
  depends_on "rust" => :build
  # Upstream only supports Hypervisor.framework on arm64
  depends_on arch: :arm64
  depends_on "dtc"
  depends_on "libepoxy"
  depends_on "libkrunfw"
  depends_on "virglrenderer"
  depends_on "xz"

  def install
    system "make", "BLK=1", "NET=1", "GPU=1", "TIMESYNC=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libkrun.h>
      int main()
      {
         int c = krun_create_ctx();
         return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lkrun", "-o", "test"
    system "./test"
  end
end
