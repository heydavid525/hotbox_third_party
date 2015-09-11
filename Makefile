THIRD_PARTY := $(shell readlink $(dir $(lastword $(MAKEFILE_LIST))) -f)
THIRD_PARTY_CENTRAL = $(THIRD_PARTY)/central
THIRD_PARTY_SRC = $(THIRD_PARTY)/src
THIRD_PARTY_INCLUDE = $(THIRD_PARTY)/include
THIRD_PARTY_LIB = $(THIRD_PARTY)/lib
THIRD_PARTY_BIN = $(THIRD_PARTY)/bin

all: third_party_core

third_party_core: path \
	                gflags \
                  glog \
									gtest \
                  gperftools \
								  snappy \
									boost \
									protobuf3 \
									zeromq \
									folly


third_party_all: third_party_core \
									protobuf \
                  oprofile \
                  libconfig \
									cuckoo \
									yaml-cpp \
									leveldb \
									float_compressor \
									openblas \
                  sparsehash \
									eigen \
									fastapprox \
									double-conversion

distclean:
	rm -rf $(THIRD_PARTY_INCLUDE) $(THIRD_PARTY_LIB) $(THIRD_PARTY_BIN) \
		$(THIRD_PARTY_SRC) $(THIRD_PARTY)/share

# These might not build.
third_party_unused: iftop

.PHONY: third_party_core third_party_all third_party_unused distclean

path:
	mkdir -p $(THIRD_PARTY_LIB)
	mkdir -p $(THIRD_PARTY_INCLUDE)
	mkdir -p $(THIRD_PARTY_BIN)
	mkdir -p $(THIRD_PARTY_SRC)

# ==================== boost ====================

BOOST_SRC = $(THIRD_PARTY_CENTRAL)/boost_1_58_0.tar.bz2
BOOST_INCLUDE = $(THIRD_PARTY_INCLUDE)/boost

boost: path $(BOOST_INCLUDE)

$(BOOST_INCLUDE): $(BOOST_SRC)
	tar jxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./bootstrap.sh \
		--prefix=$(THIRD_PARTY); \
	./b2 install

# ===================== cuckoo =====================

CUCKOO_SRC = $(THIRD_PARTY_CENTRAL)/libcuckoo.tar
CUCKOO_INCLUDE = $(THIRD_PARTY_INCLUDE)/libcuckoo

cuckoo: path $(CUCKOO_SRC)
	tar xf $(CUCKOO_SRC) -C $(THIRD_PARTY_SRC); \
	cp -r $(THIRD_PARTY_SRC)/libcuckoo/libcuckoo $(THIRD_PARTY_INCLUDE)/

$(CUCKOO_INCLUDE): $(CUCKOO_SRC)
	tar xf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	autoreconf -fis; \
	./configure --prefix=$(THIRD_PARTY); \
	make; make install

# ==================== double-conversion ===================

DCONVERT_SRC = $(THIRD_PARTY_CENTRAL)/double-conversion-1.1.5.tar.gz
DCONVERT_LIB = $(THIRD_PARTY_LIB)/libdouble-conversion.so

double-conversion: path $(DCONVERT_LIB)

$(DCONVERT_LIB): $(DCONVERT_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	scons DESTDIR=. install; \
	cp usr/local/lib/* $(THIRD_PARTY_LIB); \
	mkdir -p $(THIRD_PARTY_INCLUDE)/double-conversion; \
	cp src/double-conversion.h $(THIRD_PARTY_INCLUDE)/double-conversion

# ==================== eigen ====================

EIGEN_SRC = $(THIRD_PARTY_CENTRAL)/eigen-3.2.4.tar.bz2
EIGEN_INCLUDE = $(THIRD_PARTY_INCLUDE)/Eigen

eigen: path $(EIGEN_INCLUDE)

$(EIGEN_INCLUDE): $(EIGEN_SRC)
	tar jxf $< -C $(THIRD_PARTY_SRC)
	cp -r $(THIRD_PARTY_SRC)/eigen-eigen-10219c95fe65/Eigen \
		$(THIRD_PARTY_INCLUDE)/

# ==================== fastapprox ===================

FASTAPPROX_SRC = $(THIRD_PARTY_CENTRAL)/fastapprox-0.3.2.tar.gz
FASTAPPROX_INC = $(THIRD_PARTY_INCLUDE)/fastapprox

fastapprox: path $(FASTAPPROX_INC)

$(FASTAPPROX_INC): $(FASTAPPROX_SRC)
	tar xzf $< -C $(THIRD_PARTY_SRC)
	mkdir $(THIRD_PARTY_INCLUDE)/fastapprox
	cp $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<)))/src/*.h \
		$(THIRD_PARTY_INCLUDE)/fastapprox

# ==================== float_compressor ====================

FC_SRC = $(THIRD_PARTY_CENTRAL)/float16_compressor.hpp

float_compressor: path
	cp $(THIRD_PARTY_CENTRAL)/float16_compressor.hpp $(THIRD_PARTY_INCLUDE)/

# ===================== folly =====================

FOLLY_SRC = $(THIRD_PARTY_CENTRAL)/folly-0.57.0.tar.gz
FOLLY_LIB = $(THIRD_PARTY_LIB)/libdouble-conversion.so

folly: path $(DCONVERT_LIB)

$(FOLLY_LIB): double-convert $(FOLLY_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	autoreconf -ivf; \
	CPPFLAGS=-I$(THIRD_PARTY_INCLUDE) LD_LIBRARY_PATH=$(THIRD_PARTY_LIB) \
	LDFLAGS=-L$(THIRD_PARTY_LIB) ./configure --prefix=$(THIRD_PARTY) \
	--with-boost-libdir=$(THIRD_PARTY_LIB); \
	make -j4 && make -j4 check && make install

# ===================== gflags ===================

GFLAGS_SRC = $(THIRD_PARTY_CENTRAL)/gflags-2.0.tar.gz
GFLAGS_LIB = $(THIRD_PARTY_LIB)/libgflags.so

gflags: path $(GFLAGS_LIB)

$(GFLAGS_LIB): $(GFLAGS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ===================== glog =====================

GLOG_SRC = $(THIRD_PARTY_CENTRAL)/glog-0.3.3.tar.gz
GLOG_LIB = $(THIRD_PARTY_LIB)/libglog.so

glog: $(GLOG_LIB)

$(GLOG_LIB): $(GLOG_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ================== gperftools =================

GPERFTOOLS_SRC = $(THIRD_PARTY_CENTRAL)/gperftools-2.4.tar.gz
GPERFTOOLS_LIB = $(THIRD_PARTY_LIB)/libtcmalloc.so

gperftools: path $(GPERFTOOLS_LIB)

$(GPERFTOOLS_LIB): $(GPERFTOOLS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY) --enable-frame-pointers; \
	make install

# ===================== gtest ====================

GTEST_SRC = $(THIRD_PARTY_CENTRAL)/gtest-1.7.0.zip
GTEST_LIB = $(THIRD_PARTY_LIB)/libgtest_main.a
GTEST_LIB2 = $(THIRD_PARTY_LIB)/libgtest.a

gtest: path $(GTEST_LIB)

$(GTEST_LIB): $(GTEST_SRC)
	rm -rf $(THIRD_PARTY_SRC)/$(basename $(notdir $<))
	rm -rf $(THIRD_PARTY_INCLUDE)/gtest
	unzip $< -d $(THIRD_PARTY_SRC)
	cd $(basename $(THIRD_PARTY_SRC)/$(notdir $<))/make; \
	make; make gtest.a; \
	./sample1_unittest; \
	cp -r ../include/* $(THIRD_PARTY_INCLUDE)/; \
	cp gtest_main.a $@; \
	cp gtest.a $(GTEST_LIB2)

# ==================== leveldb ===================

LEVELDB_SRC = $(THIRD_PARTY_CENTRAL)/leveldb-1.18.tar.gz
LEVELDB_LIB = $(THIRD_PARTY_LIB)/libleveldb.so

leveldb: path $(LEVELDB_LIB)

$(LEVELDB_LIB): $(LEVELDB_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	LIBRARY_PATH=$(THIRD_PARTY_LIB):${LIBRARY_PATH} \
	make; \
	cp ./libleveldb.* $(THIRD_PARTY_LIB)/; \
	cp -r include/* $(THIRD_PARTY_INCLUDE)/

# ==================== libconfig ===================

LIBCONFIG_SRC = $(THIRD_PARTY_CENTRAL)/libconfig-1.4.9.tar.gz
LIBCONFIG_LIB = $(THIRD_PARTY_LIB)/libconfig++.so

libconfig: path $(LIBCONFIG_LIB)

$(LIBCONFIG_LIB): $(LIBCONFIG_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY) --enable-frame-pointers; \
	make install

# ==================== yaml-cpp ===================

YAMLCPP_SRC = $(THIRD_PARTY_CENTRAL)/yaml-cpp-0.5.1.tar.gz
YAMLCPP_MK = $(THIRD_PARTY_CENTRAL)/yaml-cpp.mk
YAMLCPP_LIB = $(THIRD_PARTY_LIB)/libyaml-cpp.a

yaml-cpp: boost $(YAMLCPP_LIB)

$(YAMLCPP_LIB): $(YAMLCPP_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	make -f $(YAMLCPP_MK) BOOST_PREFIX=$(THIRD_PARTY) TARGET=$@; \
	cp -r include/* $(THIRD_PARTY_INCLUDE)/

# =================== oprofile ===================
# NOTE: need libpopt-dev binutils-dev

OPROFILE_SRC = $(THIRD_PARTY_CENTRAL)/oprofile-1.0.0.tar.gz
OPROFILE_LIB = $(THIRD_PARTY_LIB)/libprofiler.so

oprofile: path $(OPROFILE_LIB)

$(OPROFILE_LIB): $(OPROFILE_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY) && \
	make install

# ==================== openblas ===================
# NOTE: need binutils-dev (libiberty)

OPENBLAS_SRC = $(THIRD_PARTY_CENTRAL)/open_blas-0.2.14.tar.gz
OPENBLAS_LIB = $(THIRD_PARTY_LIB)/libopenblas.so

openblas: path $(OPENBLAS_LIB)

$(OPENBLAS_LIB): $(OPENBLAS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	make && make install PREFIX=$(THIRD_PARTY)

# =================== protobuf ===================

PROTOBUF_SRC = $(THIRD_PARTY_CENTRAL)/protobuf-2.6.1.tar.gz
PROTOBUF_LIB = $(THIRD_PARTY_LIB)/libprotobuf.so

protobuf: path $(PROTOBUF_LIB)

$(PROTOBUF_LIB): $(PROTOBUF_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY) && \
	make && make check && make install

# =================== protobuf3 ===================

PROTOBUF3_SRC = $(THIRD_PARTY_CENTRAL)/protobuf-3.0.0-beta-1.tar.gz
PROTOBUF3_LIB = $(THIRD_PARTY_LIB)/libprotobuf-lite.a

protobuf3: path $(PROTOBUF3_LIB)

$(PROTOBUF3_LIB): $(PROTOBUF3_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./autogen.sh ; \
	./configure --prefix=$(THIRD_PARTY) && \
	make && make check && make install; \
	cd python; \
	python setup.py build; \
	cp -r build/lib/* $(THIRD_PARTY_INCLUDE)

# ================== sparsehash ==================

SPARSEHASH_SRC = $(THIRD_PARTY_CENTRAL)/sparsehash-2.0.2.tar.gz
SPARSEHASH_INCLUDE = $(THIRD_PARTY_INCLUDE)/sparsehash

sparsehash: path $(SPARSEHASH_INCLUDE)

$(SPARSEHASH_INCLUDE): $(SPARSEHASH_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ==================== snappy ===================

SNAPPY_SRC = $(THIRD_PARTY_CENTRAL)/snappy-1.1.2.tar.gz
SNAPPY_LIB = $(THIRD_PARTY_LIB)/libsnappy.so

snappy: path $(SNAPPY_LIB)

$(SNAPPY_LIB): $(SNAPPY_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# ==================== zeromq ====================

ZMQ_SRC = $(THIRD_PARTY_CENTRAL)/zeromq-4.1.2.tar.gz
ZMQ_LIB = $(THIRD_PARTY_LIB)/libzmq.so

zeromq: path $(ZMQ_LIB)

$(ZMQ_LIB): $(ZMQ_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
	./configure --prefix=$(THIRD_PARTY) --without-libsodium; \
	make install
	cp $(THIRD_PARTY_CENTRAL)/zmq.hpp $(THIRD_PARTY_INCLUDE)

# ==================== zeromq-3.2.5 ====================

#ZMQ_SRC = $(THIRD_PARTY_CENTRAL)/zeromq-3.2.5.tar.gz
#ZMQ_LIB = $(THIRD_PARTY_LIB)/libzmq.so
#
#zeromq: path $(ZMQ_LIB)
#
#$(ZMQ_LIB): $(ZMQ_SRC)
#	tar zxf $< -C $(THIRD_PARTY_SRC)
#	cd $(basename $(basename $(THIRD_PARTY_SRC)/$(notdir $<))); \
#	./configure --prefix=$(THIRD_PARTY); \
#	make install
#	cp $(THIRD_PARTY_CENTRAL)/zmq.hpp $(THIRD_PARTY_INCLUDE)


####################### Unused #####################



# ================== iftop ==================

IFTOP_SRC = $(THIRD_PARTY_CENTRAL)/iftop-1.0pre4.tar.gz
IFTOP_BIN = $(THIRD_PARTY_BIN)/iftop

iftop: path $(IFTOP_BIN)

$(IFTOP_BIN): $(IFTOP_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install; \
	cp iftop $(IFTOP_BIN)

