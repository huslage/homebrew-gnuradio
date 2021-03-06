require "formula"

class Gnuradio < Formula
  homepage "http://gnuradio.org"
  head "https://github.com/gnuradio/gnuradio.git"
  url "https://www.gnuradio.org/releases/gnuradio/gnuradio-3.7.13.3.tar.xz"
  sha256 "b05310982e3c1f40e7c533e5957520cc6a830cf586b134fdf272e9397451e5f4"

  option "without-qt", "Build with QT widgets in addition to wxWidgets"
  option "without-docs", "Build gnuradio documentation"

  depends_on "python@2"
  build.without? "python-deps"
  depends_on "Cheetah"
  depends_on "lxml"
  depends_on "matplotlib"
  depends_on "numpy"
  depends_on "scipy"
  depends_on "docutils"
  depends_on "gfortran" => :build
  depends_on "swig" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cppunit"
  depends_on "gsl"
  depends_on "fftw"
  depends_on "sip"
  depends_on "pygobject"
  depends_on "pygtk"
  depends_on "sdl"
  depends_on "libusb"
  depends_on "orc"
  depends_on "pyqt" if build.with? "qt"
  depends_on "pyqwt" if build.with? "qt"
  depends_on "sphinx" if build.with? "docs"
  depends_on "wxpython"
  depends_on "wxmac"
  depends_on "freetype"

  def install
    mkdir "build" do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
        -DENABLE_DOXYGEN=Off
        -DCMAKE_C_COMPILER=#{ENV.cc}
        -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      ]
      # Find the right python, system or homebrew.
      args << "-DPYTHON_EXECUTABLE='#{%x(python-config --prefix).chomp}/bin/python'"
      args << "-DPYTHON_INCLUDE_DIR='#{%x(python-config --prefix).chomp}/include/python2.7'"
      args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      if build.with? "docs"
        args << "-DENABLE_SPHINX=ON"
      else
        args << "-DENABLE_SPHINX=OFF"
      end

      if build.with? "qt"
        args << "-DENABLE_GR_QTGUI=ON"
      else
        args << "-DENABLE_GR_QTGUI=OFF"
      end

      system "cmake", "..", *args, *std_cmake_args
      system "make"
      system "make install"
      inreplace "#{prefix}/etc/gnuradio/conf.d/grc.conf" do |s|
        s.gsub! "#{prefix}/", "#{HOMEBREW_PREFIX}/"
      end
    end
  end
end
